{ ... }: {
  imports = [
    ../../common
    ../../profiles/dn42de
    ../../profiles/headless
    ../../profiles/systemd-boot
    ../../services/netbox
    ./hardware-configuration.nix
  ];

  networking.hostName = "falkdn42";
  networking.domain = "aprilthe.pink";

  virtualisation.docker.enable = true;

  zramSwap.enable = true;
}
