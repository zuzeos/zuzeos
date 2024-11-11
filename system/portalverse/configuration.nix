{ pkgs, lib, ... }: {
  imports = [
    ../../common
    ../../profiles/headless
    ../../profiles/systemd-boot
    ../../profiles/default-disko-config
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
    extraPlugins = ps: with ps; [ postgis pg_repack repmgr pg_uuidv7 ];
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
  
  system.stateVersion = lib.mkForce "23.11";
}
