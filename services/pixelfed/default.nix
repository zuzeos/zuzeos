{ lib, config, pkgs, ... }: {
  services.pixelfed = {
    domain = "polaroid.girlthing.de";
    enable = true;
    settings.APP_DEBUG = true;
    secretFile = "/usr/pixel.env";
    phpPackage = pkgs.php84;
  };

  services.mysql.enable = lib.mkForce true;

  services.nginx.virtualHosts."polaroid.girlthing.de" = {
    forceSSL = lib.mkForce true;
    enableACME = lib.mkForce true;
    serverAliases = [ "pics.girlthing.de" "p2.girlthing.de" ];
    root = lib.mkForce "${config.services.pixelfed.package.override { inherit (config.services.pixelfed) dataDir runtimeDir; }}/public/";
          locations."/".tryFiles = "$uri $uri/ /index.php?$query_string";
          locations."/favicon.ico".extraConfig = ''
            access_log off; log_not_found off;
          '';
          locations."/robots.txt".extraConfig = ''
            access_log off; log_not_found off;
          '';
          locations."~ \\.php$".extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.pixelfed.socket};
            fastcgi_index index.php;
          '';
          locations."~ /\\.(?!well-known).*".extraConfig = ''
            deny all;
          '';
          extraConfig = ''
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Content-Type-Options "nosniff";
            index index.html index.htm index.php;
            error_page 404 /index.php;
          '';
  };
}
