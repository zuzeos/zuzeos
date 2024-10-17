{ pkgs, lib, inputs, ... }:
{
  imports = [
    ./bird-general.nix
  ];
  environment.systemPackages = with pkgs; [ 
    # Network debug tools
    dnsutils
    mtr
    tcpdump
    wireguard-tools
  ];
}
