{ pkgs, lib, ... }: {
  imports = [
    ../../common
    ../../profiles/headless
    ../../profiles/systemd-boot
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  zuze.deployment = {
    targetHost = "37.27.9.168";
    tags = [
      "dn42de"
    ];
  };
  networking.hostName = "heldn42";
  networking.domain = "";

  virtualisation.docker.enable = true;

  boot.loader.grub.enable = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;

  zramSwap.enable = true;
}
