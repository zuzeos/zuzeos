{
  lib,
  pkgs,
  config,
  ...
}:
let
  # add nginx reverse proxy and ACME web certificate
  add_nginx = true;

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

  acmeDomain = lemmy.domain;
  nginxVhost = lemmy.domain;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../baseconf.nix
    ../../disk-config.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "moralitycore";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPKL1+FX6pt3EasE9ZIb9Qg+LvFVagAVi2Uy9X2E90n aprl@acab.dev"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxsX+lEWkHZt9NOvn9yYFP0Z++186LY4b97C4mwj/f2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpyVefbZLkNVNzdSIlO6x6JohHE1snoHiUB3Qdvl5I2"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0v3tUBNEUxfoOQBFb+N2DUBQDay0iFggUWa9Nd+BtFLOKkz+RRto3eBF0ZiJZVUxv/hLb8m2s45hcMw8agwuPrXMe5085T1fzkvPdKAPZdsT/cCmBi1OsoLjAKBFIdM4lcV0A2cca8hip+/ZPpjFPUWx73/672gAPHU7co7fP8+8CSf9dx+WIeLx3yaYHYZ/th3dB5auX3VjOazS8MojsAorwTUeBoPamHQ5dFeNafhFUL/hhtGkUI1cNHUn3bJd2V7AKTW3UglK7hVgMJPrzVS31OlpcJEf6S5XgKTWdOSwubn1bs5Lt6YYRDU24NV6CGrwKgCJSRxzNMLwpnFKiSXpO8FzkqWHYWyju141hQcFF31aZIV+7YcwEt5ZukLjFOpVtpbSXvJYigOUzGi34P3/OAGshDXjTQjvM8GIir49gx3b2Nwhg0z4UHBkAKZvDDFPHDMJoclvnhITojaAojfC9zmMCO5ZaEsk8yv7c/lWQumzRpfldWF4mwHvhD5kTADbhRdO7WTdX7AaiAYINooToeWKjFe2wn3rFubPUppptqtP03mmvs7vhhgnEVBbGZRJK3GTVk1XcsfF9rDKzewSa+wb4LsBoZtFRhc8cJqHGlKWSNk7dQ04B1atPyNLKGpGoo/UIPxyZ6bSqFVxY3nhz46VZ6z8XWI48z0/fRQ=="
  ];

  #services.lysand.ap = {
  #  enable = true;
  #  domain = "lysand.fediverse.gay";
  #  nginx.enable = true;
  #};

  services.postgresql.enable = true;

  services.prometheus.exporters.node = {
    enable = true;
    port = 9000;
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/exporters.nix
    enabledCollectors = [ "systemd" ];
    # /nix/store/zgsw0yx18v10xa58psanfabmg95nl2bb-node_exporter-1.8.1/bin/node_exporter  --help
    extraFlags = [
      "--collector.ethtool"
      "--collector.softirqs"
      "--collector.tcpstat"
      "--collector.wifi"
    ];
  };

  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s"; # "1m"
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          { targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ]; }
        ];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        # Listening Address
        http_addr = "127.0.0.1";
        # and Port
        http_port = 3000;
        # Grafana needs to know on which domain and URL it's running
        domain = "dash.fedinet.org";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "aprl@acab.dev";
  };

  services.mattermost = {
    enable = true;
    siteUrl = "https://fedinet.org";
    mutableConfig = true;
    plugins = [ ./reactions.tar.gz ];
  };

  systemd.services.pocketbase = {
    script = "${pkgs.pocketbase}/bin/pocketbase serve --encryptionEnv=PB_ENCRYPTION_KEY --dir /var/pb_data";
    serviceConfig = {
      LimitNOFILE = 4096;
      EnvironmentFile = [ "/var/pbsecret" ];
    };
    wantedBy = [ "multi-user.target" ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    upstreams."${lemmy.upstreamName}".servers."${lemmy.ip}:${builtins.toString lemmy.port}" = { };
    upstreams."${lemmy-ui.upstreamName}".servers."${lemmy-ui.ip}:${builtins.toString lemmy-ui.port}" =
      { };
    virtualHosts = {
      # Replace with the domain from your siteUrl
      "fedinet.org" = {
        forceSSL = true; # Enforce SSL for the site
        enableACME = true; # Enable SSL for the site
        locations."/" = {
          proxyPass = "http://127.0.0.1:8065"; # Route to Mattermost
          proxyWebsockets = true;
        };
      };
      "dash.fedinet.org" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };
      "waschkatzen.de" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8090";
          proxyWebsockets = true;
        };
      };
      "${nginxVhost}" = {
        enableACME = true;
        # add redirects from http to https
        forceSSL = true;
        # this whole block was lifted from https://github.com/LemmyNet/lemmy/blob/ef1aa18fd20cc03d492a81cb70cc75cf3281649f/docker/nginx.conf#L21 lines 21-32
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
            # again, lifted wholesale from https://github.com/LemmyNet/lemmy/blob/ef1aa18fd20cc03d492a81cb70cc75cf3281649f/docker/nginx.conf#L36 lines 36-55
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

          # again, lifted wholesale from https://github.com/LemmyNet/lemmy/blob/ef1aa18fd20cc03d492a81cb70cc75cf3281649f/docker/nginx.conf#L60 lines 60-69 (nice!)
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
  };

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

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  system.stateVersion = "23.11";
}
