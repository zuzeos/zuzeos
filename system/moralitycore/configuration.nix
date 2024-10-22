{ lib, config, ... }: {
  imports = [
    ../../common
    ../../profiles/default-disko-config
    ../../profiles/headless
    ../../services/grafana
    ../../services/lemmy
    ../../services/mattermost
    ../../services/nginx
    ../../services/pocketbase
    ./hardware-configuration.nix
  ];

  zuze.deployment = {
    targetHost = "morality.fediverse.gay";
    tags = [
      "web"
      "infra-ap"
      "infra-ls"
    ];
  };

  networking.hostName = "moralitycore";
  networking.domain = "";

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
    # /nix/store/xx-node_exporter-1.8.1/bin/node_exporter  --help
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

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  system.stateVersion = lib.mkForce "23.11";
}
