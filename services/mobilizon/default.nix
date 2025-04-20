{ config, lib, pkgs, ... }: {

  services.mobilizon = {
    enable = true;
    settings =
      let
        # These are helper functions, that allow us to use all the features of the Mix configuration language.
        # - mkAtom and mkRaw both produce "raw" strings, which are not enclosed by quotes.
        # - mkGetEnv allows for convenient calls to System.get_env/2
        inherit ((pkgs.formats.elixirConf { }).lib) mkAtom mkRaw mkGetEnv;
      in
        {
          ":mobilizon" = {

            # General information about the instance
            ":instance" = {
              name = "Queerfeminine Event Site";
              description = "A instance for queerfeminine  friendly events";
              hostname = "events.estrogen.jetzt";
              email_from = "noreply@versia.pub";
              email_reply_to = "aprl@acab.dev";
            };

            # SMTP configuration
            "Mobilizon.Web.Email.Mailer" = {
              adapter = mkAtom "Swoosh.Adapters.SMTP";
              relay = "mail.versia.pub";
              # usually 25, 465 or 587
              port = 587;
              username = "noreply@versia.pub";
              # See "Providing a SMTP password" below
              password = mkGetEnv { envVariable = "SMTP_PASSWORD"; };
              tls = mkAtom ":always";
              allowed_tls_versions = [
                (mkAtom ":tlsv1")
                (mkAtom ":\"tlsv1.1\"")
                (mkAtom ":\"tlsv1.2\"")
              ];
              retries = 1;
              no_mx_lookups = false;
              auth = mkAtom ":always";
            };

            "Mobilizon.Storage.Repo" = let
              inherit ((pkgs.formats.elixirConf { }).lib) mkAtom mkRaw mkGetEnv;
            in {
              socket_dir = null;
              hostname = "mobilizon.fly.dev";
              username = "postgres";
              database = "mobilizon";
              password = mkGetEnv { envVariable = "POSTGRES_PASSWORD"; };
              port = 5432;
              pool_size = 10;
              ssl = false;
            };

          };
        };
  };

  # In order for Nginx to be publicly accessible, the firewall needs to be configured.
  networking.firewall.allowedTCPPorts = [
    80  # HTTP
    443 # HTTPS
  ];

  # For using the Let's Encrypt TLS certificates for HTTPS,
  # you have to accept their TOS and supply an email address.
  security.acme = {
    acceptTerms = true;
  };

}