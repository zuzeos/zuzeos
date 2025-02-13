{ pkgs, ... }: let
  script = pkgs.writeShellScriptBin "update-roa" ''
    mkdir -p /etc/bird/
    ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42_v6.conf https://dn42.burble.com/roa/dn42_roa_bird2_6.conf
    ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42.conf https://dn42.burble.com/roa/dn42_roa_bird2_4.conf
    ${pkgs.bird2}/bin/birdc c 
    ${pkgs.bird2}/bin/birdc reload in all
  '';
in
{
  imports = [
    ./wg.nix
    ./bird2.nix
  ];

  systemd.timers.dn42-roa = {
    description = "Trigger a ROA table update";

    timerConfig = {
      OnBootSec = "5m";
      OnUnitInactiveSec = "1h";
      Unit = "dn42-roa.service";
    };

    wantedBy = [ "timers.target" ];
    before = [ "bird.service" ];
  };

  systemd.services = {
    dn42-roa = {
      after = [ "network.target" ];
      description = "DN42 ROA Updated";
      serviceConfig = {
        # Type = "one-shot";
        ExecStart = "${script}/bin/update-roa";
      };
    };
  };
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

  networking.interfaces.lo = {
    ipv4.addresses = [
      { address = "172.23.45.226"; prefixLength = 32; }
    ];
    ipv6.addresses = [
      { address = "fd42:acab:f00d:1001::1"; prefixLength = 128; }
    ];
  };
}
