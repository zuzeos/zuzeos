{ lib, config, ... }: {
  imports = [
    ../../common
    ../../profiles/default-disko-config
    ../../profiles/headless
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

  services.postgresql.enable = true;

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  system.stateVersion = lib.mkForce "23.11";
}
