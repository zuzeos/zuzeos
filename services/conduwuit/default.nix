{ pkgs, lib, config, ... }: {
  services.matrix-continuwuity = {
    enable = true;
    settings = {
      global = {
        trusted_servers = [
          "matrix.org"
          "uwu.is"
          "ccc-ffm.de"
          "catgirl.industries"
          "fairydust.space"
        ];
        server_name = "estrogen.jetzt";
        database_backend = "rocksdb";
        new_user_displayname_suffix = " | 🏳️‍⚧️";
        ip_lookup_strategy = 4;
        allow_registration = true;
        registration_token_file = "/etc/.conduwuit_reg_token";
        allow_public_room_directory_over_federation = true;
      };
    };
  };
  services.nginx.virtualHosts."im.estrogen.jetzt" = {
    forceSSL = true;
    enableACME = true;
    locations."/_matrix/" = {
      proxyPass = "http://[::1]:${toString config.services.matrix-continuwuity.settings.global.port}";
      proxyWebsockets = true;
    };
  };
  services.nginx.virtualHosts."estrogen.jetzt" = {
    forceSSL = true;
    enableACME = true;
    listen = [{port = 8448;  addr="0.0.0.0"; ssl = true;}{port = 443;  addr="0.0.0.0"; ssl = true;}];
    locations."/.well-known/matrix/" = {
      root = "/usr/mtx-well-known";
    };
    locations."/_matrix/" = {
      proxyPass = "http://[::1]:${toString config.services.matrix-continuwuity.settings.global.port}";
      proxyWebsockets = true;
    };
  };
}
