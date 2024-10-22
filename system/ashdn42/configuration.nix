{ ... }: {
  imports = [
    ../../common
    ../../profiles/dn42de
    ../../profiles/headless
    ../../profiles/systemd-boot
    ./hardware-configuration.nix
  ];

  zuze.deployment = {
    targetHost = "5.161.236.38";
    tags = [ "dn42de" ];
  };
  networking.hostName = "ashdn42";

  time.timeZone = "America/New_York";

  virtualisation.docker.enable = true;

  zramSwap.enable = true;
}
