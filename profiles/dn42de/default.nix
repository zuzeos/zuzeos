{ pkgs, lib, inputs, ... }:
{
  imports = [
    ./bird-general.nix
    ./disko-config.nix
  ];
  environment.systemPackages = with pkgs; [ 
    # Network debug tools
    dnsutils
    mtr
    tcpdump
    wireguard-tools
  ];

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.rp_filter" = 0;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.default.rp_filter" = 0;
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
