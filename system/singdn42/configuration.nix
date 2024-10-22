{ ... }: {
  imports = [
    ../../common
    ../../profiles/dn42de
    ../../profiles/headless
    ../../profiles/systemd-boot
    ./hardware-configuration.nix
  ];

  zuze.deployment = {
    targetHost = "5.223.43.218";
    tags = [
      "dn42de"
    ];
  };
  networking.hostName = "singdn42";

  time.timeZone = "Asia/Singapore";

  virtualisation.docker.enable = true;

  zramSwap.enable = true;
}
