{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "1.1.1.1" "1.0.0.1"
 ];
    dhcpcd.enable = true;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="135.181.150.242"; prefixLength=32; }
        ];
        ipv6.addresses = [
          { address="2a01:4f9:c012:de9b::1"; prefixLength=64; }
{ address="fe80::9400:3ff:fe43:177c"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "172.31.1.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = "fe80::1"; prefixLength = 128; } ];
      };
      
    };
  };
}
