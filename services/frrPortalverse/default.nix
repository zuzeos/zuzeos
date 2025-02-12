{ pkgs, ... }: {
  imports = [
    ./wg.nix
  ];
  services.frr = {
    ripd.enable = true;
    config = ''
      ip forwarding
      ipv6 forwarding
      !
      router rip
        version 2
        network 45.150.123.22/32
        network 2a0f:be01:0:102::600/128
        network 10.100.126.16/32
        network fe80::ada0/128
        network fe80::ade0/128
        # Example: network 192.168.1.0/24
        # (Advertise all interfaces in this subnet)
        passive-interface lo
        redistribute static
        redistribute connected
    '';
  };
  systemd.network = {
    config.networkConfig = {
      IPv4Forwarding = true;
      IPv6Forwarding = true;
    };
  };
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.rp_filter" = 0;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.default.rp_filter" = 0;
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  environment.systemPackages = with pkgs; [ 
    # Network debug tools
    dnsutils
    mtr
    tcpdump
    wireguard-tools
  ];

  networking.firewall.trustedInterfaces = [];

  networking.firewall.allowedTCPPorts = [
    25508
    25509
  ];
  networking.firewall.allowedUDPPorts = [
    25508
    25509
  ];
}
