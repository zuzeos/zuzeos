{ ... }: {
  imports = [
    ../../common
    ../../profiles/dn42de
    ../../profiles/headless
    ../../profiles/systemd-boot
    ./hardware-configuration.nix
  ];

  zuze.deployment = {
    targetHost = "37.27.9.168";
    tags = [
      "dn42de"
    ];
  };
  networking.hostName = "heldn42";

  virtualisation.docker.enable = true;

  zramSwap.enable = true;
}
