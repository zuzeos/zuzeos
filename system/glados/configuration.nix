{ lib, ... }: {
  imports = [
    ../../common
    ../../profiles/headless
    ../../profiles/default-disko-config
    ./hardware-configuration.nix
  ];

  zramSwap.enable = true;
  networking.hostName = "glados";
  networking.domain = "";

  #services.lysand.ap = {
  #  enable = true;
  #  domain = "lysand.fediverse.gay";
  #  nginx.enable = true;
  #};

  services.postgresql.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "aprl@acab.dev";
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];
  
  system.stateVersion = lib.mkForce "23.11";
}
