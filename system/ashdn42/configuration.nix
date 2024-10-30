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
  networking = {
    firewall = {
      checkReversePath = false;
      extraCommands = ''
        ${pkgs.iptables}/bin/iptables -A INPUT -s 192.168.65.5/24 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -A INPUT -s 172.23.105.176/28 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -A INPUT -s fd48:a412:cc60::/48 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -A INPUT -s fe80::/64 -j ACCEPT
      '';
    };
    interfaces.lo = {
      ipv4.addresses = [
        { address = "192.168.65.5"; prefixLength = 32; }
        { address = "172.23.105.176"; prefixLength = 28; }
      ];
      ipv6.addresses = [
        { address = "fd48:a412:cc60:aa00::"; prefixLength = 56; }
        { address = "fd48:a412:cc60::"; prefixLength = 56; } # anycast
        { address = "fe80::aca5"; prefixLength = 128; }
      ];
    };
  };

  virtualisation.docker.enable = true;

  zramSwap.enable = true;
}
