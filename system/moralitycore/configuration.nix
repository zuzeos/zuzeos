{ lib, pkgs, config, ... }: {
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
    extraFlags = [ "--collector.ethtool" "--collector.softirqs" "--collector.tcpstat" "--collector.wifi" ];
  };

  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s"; # "1m"
    scrapeConfigs = [
    {
      job_name = "node";
      static_configs = [{
        targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
      }];
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
    plugins = [
      ./reactions.tar.gz
    ];
  };

  systemd.services.pocketbase = {
    script = "${pkgs.pocketbase}/bin/pocketbase serve --encryptionEnv=PB_ENCRYPTION_KEY --dir /var/pb_data";
    serviceConfig = {
      LimitNOFILE = 4096;
      EnvironmentFile = ["/var/pbsecret"];
    };
    wantedBy = [ "multi-user.target" ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;    
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
    };
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];
  
  system.stateVersion = "23.11";
}
