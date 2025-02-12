{ config, pkgs, lib, ... }:
let
  defaultLocalIPv4 = "10.100.126.16/32";
  defaultLocalIPv6 = "fe80::aca3/128";
in
{
  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking.wireguard.interfaces = import peers/tunnels.nix rec {
    customTunnel = listenPort: privateKey: publicKey: endpoint: name: tunnelIPv4: tunnelIPv6: localIPv4: localIPv6: notonlyListen: {
      listenPort = listenPort;
      privateKeyFile = privateKey;
      allowedIPsAsRoutes = false;
      peers = [
        {
          publicKey = publicKey;
          allowedIPs = [ tunnelIPv4 tunnelIPv6 "0.0.0.0/0" "::/0" ];
          endpoint = lib.mkIf notonlyListen endpoint;
          dynamicEndpointRefreshSeconds = lib.mkIf notonlyListen 5;
        }
      ];
      postSetup = ''
        ${lib.optionalString (tunnelIPv4 != null) "${pkgs.iproute2}/bin/ip addr add ${localIPv4} peer ${tunnelIPv4} dev ${name}"}
        ${lib.optionalString (tunnelIPv6 != null) "${pkgs.iproute2}/bin/ip -6 addr add ${localIPv6} peer ${tunnelIPv6} dev ${name}"}
      '';
    };
    tunnel = listenPort: privateKey: publicKey: endpoint: name: tunnelIPv4: tunnelIPv6: notonlyListen: customTunnel listenPort privateKey publicKey endpoint name tunnelIPv4 tunnelIPv6 defaultLocalIPv4 defaultLocalIPv6 notonlyListen;
    tunnelc4 = listenPort: privateKey: publicKey: endpoint: name: tunnelIPv4: tunnelIPv6: notonlyListen: localIPv4: customTunnel listenPort privateKey publicKey endpoint name tunnelIPv4 tunnelIPv6 localIPv4 defaultLocalIPv6 notonlyListen;
    rip = listenPort: privateKey: publicKey: endpoint: name: tunnelIPv4: tunnelIPv6: ULAIPv6: notonlyListen: customTunnel listenPort privateKey publicKey endpoint name tunnelIPv4 tunnelIPv6 defaultLocalIPv4 ULAIPv6 notonlyListen;
  };
}
