{ pkgs, ... }: {
  systemd.services.pocketbase = {
    script = "${pkgs.pocketbase}/bin/pocketbase serve --encryptionEnv=PB_ENCRYPTION_KEY --dir /var/pb_data";
    serviceConfig = {
      LimitNOFILE = 4096;
      EnvironmentFile = [ "/var/pbsecret" ];
    };
    wantedBy = [ "multi-user.target" ];
  };
  services.nginx.virtualHosts."waschkatzen.de" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8090";
      proxyWebsockets = true;
    };
  };
}
