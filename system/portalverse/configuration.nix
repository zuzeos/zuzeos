{ config, pkgs, lib, ... }: {
  imports = [
    ../../common
    ../../profiles/headless
    ../../profiles/systemd-boot
    ../../services/nginx
    ../../services/webmail
    ../../services/mattermostVersia
    ../../profiles/default-disko-config
    ../../pkgs/keycloakThemes
    ./hardware-configuration.nix
  ];

  zuze.deployment = {
    targetHost = "portalverse.versia.social";
    tags = [
      "versia"
    ];
  };
  networking.hostName = "portalverse";
  networking.domain = "versia.social";

  #services.lysand.ap = {
  #  enable = true;
  #  domain = "lysand.fediverse.gay";
  #  nginx.enable = true;
  #};

  security.acme = {
    acceptTerms = true;
    defaults.email = "aprl@acab.dev";
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "reptest" ];
    enableTCPIP = true;
    extensions = ps: with ps; [ postgis pg_repack repmgr pg_uuidv7 ];
    package = pkgs.postgresql_16;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
      host    all             all             0.0.0.0/0            scram-sha-256
      host    all             all             ::/0                 scram-sha-256
    '';
    settings = {
      shared_preload_libraries = [ "repmgr" "pg_uuidv7" "pg_repack" ];
      max_wal_senders = 10;
      wal_level = "hot_standby";
      hot_standby = true;
      # todo archive_mode = true;

    };
  };

  services.prometheus.exporters.postgres = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = 9187;
  };
  services.keycloak = {
    enable = true;
    database = {
      type = "postgresql";
      createLocally = true;

      username = "keycloak";
      passwordFile = "/etc/nixos/secrets/keycloak_psql_pass";
    };
    settings = {
      hostname = "id.internal.versia.pub";
      proxy-headers = "xforwarded";
      http-port = 2345;
      http-enabled = true;
    };
    themes = with pkgs ; {
    	keywind = custom_keycloak_themes.keywind;
    };
  };

  services.nginx.virtualHosts = {
      "id.internal.versia.pub" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString config.services.keycloak.settings.http-port}/";
          };
        };
      };
      "portalverse.versia.social" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:9000/";
            proxyWebsockets = true;
          };
        };
      };
      "beta.versia.social" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://172.18.0.5:9900/";
            proxyWebsockets = true;
          };
        };
      };
      "ap.beta.versia.social" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:8080/";

            extraConfig = ''
		          proxy_set_header Host $host;
		          proxy_set_header X-Real-IP $remote_addr;
		          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		          proxy_set_header X-Forwarded-Proto $scheme;
            '';
            recommendedProxySettings = false;
          };
        };
      };
  };

  programs.zsh.enable = true;
  users.users.aprl = {
    extraGroups = [ "wheel" "pipewire" "media" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  systemd.network.networks."98-eth-default" = {
    matchConfig.Type = "ether";
    matchConfig.Name = "e*";
    address = [
      "2a0f:be01:0:100::308/128"
    ];
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = false;
    };
    routes = [
      { Gateway = "fe80::1"; }
    ];
  };

  networking = {
    interfaces.enp6s18 = {
      ipv6.addresses = [{
        address = "2a0f:be01:0:100::308";
        prefixLength = 128;
      }];
    };
  };

  mailserver = {
    enable = true;
    fqdn = "mail.versia.pub";
    domains = [ "versia.pub" ];
    certificateScheme = "acme-nginx";

    loginAccounts = {
      "aprl@versia.pub" = {
        hashedPasswordFile = "/etc/nixos/secrets/aprl_mailhash";
        aliases = [
          "april.john@versia.pub"
          "afj@versia.pub"
          "april@versia.pub"
          "john@versia.pub"
          "ja@versia.pub"
        ];
      };
      "cpluspatch@versia.pub" = {
        hashedPasswordFile = "/etc/nixos/secrets/jesse_mailhash";
        aliases = [
          "jesse.wierzbinski@versia.pub"
          "jw@versia.pub"
          "gaspard.wierzbinski@versia.pub"
        ];
      };
      "noreply@versia.pub" = {
        hashedPasswordFile = "/etc/nixos/secrets/noreply";
      };
    };

  };
  
  system.stateVersion = lib.mkForce "23.11";
}
