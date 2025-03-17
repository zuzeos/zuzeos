{ pkgs, ... }: {
  services.matrix-conduit = {
    enable = true;
    package = pkgs.conduit-ov.default;
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
}
