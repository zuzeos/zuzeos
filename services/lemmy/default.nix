{ config, lib, ... }: let
  lemmy = {
    upstreamName = "lemmy";
    dataDir = "/var/lib/lemmy";
    ip = "127.0.0.1";
    port = 1234;
    domain = "discuss.fedinet.org";
  };

  lemmy-ui = {
    upstreamName = "lemmy-ui";
    ip = "127.0.0.1";
    port = 8536;
  };

  pict-rs = {
    ip = "127.0.0.1";
    port = 8080;
  };
in {
  systemd.services.lemmy-ui = {
    environment = {
      LEMMY_UI_HOST = lib.mkForce "${lemmy-ui.ip}:${toString lemmy-ui.port}";
      LEMMY_UI_LEMMY_INTERNAL_HOST = lib.mkForce "${lemmy.ip}:${toString lemmy.port}";
      LEMMY_UI_LEMMY_EXTERNAL_HOST = lib.mkForce lemmy.domain;
      LEMMY_UI_HTTPS = lib.mkForce "true";
    };
  };

  services.pict-rs = {
    enable = true;
    port = pict-rs.port;
    dataDir = "${lemmy.dataDir}/pict-rs";
    address = pict-rs.ip;
  };

  systemd.services.lemmy = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
    environment = {
      LEMMY_DATABASE_URL = lib.mkForce "postgresql://lemmy@127.0.0.1:${toString config.services.postgresql.settings.port}/lemmy";
    };
  };

  services.lemmy = {
    enable = true;
    ui.port = lemmy-ui.port;
    database.createLocally = true;
    settings = {
      # Pictrs image server configuration.
      pictrs = {
        # Address where pictrs is available (for image hosting)
        url = "http://${pict-rs.ip}:${toString pict-rs.port}/";
        # TODO: Set a custom pictrs API key. ( Required for deleting images )
        api_key = "";
      };
      # TODO: Email sending configuration. All options except login/password are mandatory
      email = {
        # Hostname and port of the smtp server
        smtp_server = "mail.sakamoto.pl";
        # Login name for smtp server
        smtp_login = "noreply-bakka@sakamoto.pl";
        # Password to login to the smtp server
        smtp_password = "3SMdf3xeJ6JqUqjRxP2LhGQepdE63j";
        # Address to send emails from, eg "noreply@your-instance.com";
        smtp_from_address = "noreply-bakka@sakamoto.pl";
        # Whether or not smtp connections should use tls. Can be none, tls, or starttls
        tls_type = "starttls";
      };
      # TODO: Parameters for automatic configuration of new instance (only used at first start)
      setup = {
        # Username for the admin user
        admin_username = "aprl";
        # Password for the admin user. It must be at least 10 characters.
        admin_password = "changemetonewpassword";
        # Name of the site (can be changed later)
        site_name = "Lemmy at ${lemmy.domain}";
        # Email for the admin user (optional, can be omitted and set later through the website)
        admin_email = "aprl@acab.dev";
      };
      # the domain name of your instance (mandatory)
      hostname = lemmy.domain;
      # Address where lemmy should listen for incoming requests
      bind = lemmy.ip;
      # Port where lemmy should listen for incoming requests
      port = lemmy.port;
      # Whether the site is available over TLS. Needs to be true for federation to work.
      tls_enabled = true;
    };
  };
  services.nginx = {
    upstreams."${lemmy.upstreamName}".servers."${lemmy.ip}:${builtins.toString lemmy.port}" = { };
    upstreams."${lemmy-ui.upstreamName}".servers."${lemmy-ui.ip}:${builtins.toString lemmy-ui.port}" = { };
    virtualHosts."${lemmy.domain}" = {
      enableACME = true;
      # add redirects from http to https
      forceSSL = true;
      # this whole block was lifted from https://github.com/LemmyNet/lemmy/blob/main/docker/nginx.conf#L21 lines 21-32
      extraConfig = ''
        # disables emitting nginx version on error pages and in the “Server” response header field
        server_tokens off;

        gzip on;
        gzip_types text/css application/javascript image/svg+xml;
        gzip_vary on;

        # Upload limit, relevant for pictrs
        client_max_body_size 20M;

        add_header X-Frame-Options SAMEORIGIN;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
      '';

      locations = {
        "/" = {
          # we do not use the nixos "locations.<name>.proxyPass" option because the nginx config needs to do something fancy.
          # again, lifted wholesale from https://github.com/LemmyNet/lemmy/blob/main/docker/nginx.conf#L36 lines 36-55
          extraConfig = ''
            # distinguish between ui requests and backend
            # don't change lemmy-ui or lemmy here, they refer to the upstream definitions on top
            set $proxpass "http://${lemmy-ui.upstreamName}";

            if ($http_accept = "application/activity+json") {
              set $proxpass "http://${lemmy.upstreamName}";
            }
            if ($http_accept = "application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"") {
              set $proxpass "http://${lemmy.upstreamName}";
            }
            if ($request_method = POST) {
              set $proxpass "http://${lemmy.upstreamName}";
            }
            proxy_pass $proxpass;

            # Cuts off the trailing slash on URLs to make them valid
            rewrite ^(.+)/+$ $1 permanent;

            # Send actual client IP upstream
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };

        # again, lifted wholesale from https://github.com/LemmyNet/lemmy/blob/main/docker/nginx.conf#L60 lines 60-69 (nice!)
        "~ ^/(api|pictrs|feeds|nodeinfo|.well-known)" = {
          proxyPass = "http://${lemmy.upstreamName}";
          extraConfig = ''
            # proxy common stuff
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            ## Send actual client IP upstream
            #proxy_set_header X-Real-IP $remote_addr;
            #proxy_set_header Host $host;
            #proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
      };
    };
  };
}
