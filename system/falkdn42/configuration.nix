{ ... }: {
  imports = [
    ../../common
    ../../profiles/dn42de
    ../../profiles/headless
    ../../profiles/systemd-boot
    ../../services/netbox
    ./hardware-configuration.nix
  ];

  zuze.deployment = {
    targetHost = "188.245.199.114";
    tags = [
      "dn42de"
    ];
  };

  networking.hostName = "falkdn42";
  networking.domain = "aprilthe.pink";

  virtualisation.docker.enable = true;

  zramSwap.enable = true;
}
