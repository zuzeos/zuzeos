{ ... }: {
  imports = [
    ../../common
    ../../profiles/dn42de
    ../../profiles/headless
    ../../profiles/systemd-boot
    ./hardware-configuration.nix
  ];

  networking.hostName = "heldn42";

  virtualisation.docker.enable = true;

  zramSwap.enable = true;
}
