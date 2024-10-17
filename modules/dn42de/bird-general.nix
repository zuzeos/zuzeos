{ pkgs, lib, ... }:
let
  script = pkgs.writeShellScriptBin "update-roa" ''
    mkdir -p /etc/bird/
    ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42_v6.conf https://dn42.burble.com/roa/dn42_roa_bird2_6.conf
    ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42.conf https://dn42.burble.com/roa/dn42_roa_bird2_4.conf
    ${pkgs.bird2}/bin/birdc c 
    ${pkgs.bird2}/bin/birdc reload in all
  '';
in
{

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



  services = {
    bird-lg = {
      proxy = {
        enable = false; #todo
        listenAddress = "0.0.0.0:8000";
        allowedIPs = [ "127.0.0.1" "::1" "172.23.105.176/28" "fd48:a412:cc60::/48" ];
        birdSocket = "/var/run/bird/bird.ctl";
      };
      # frontend = {
      #   enable = false;
      #   servers = [ "fr-par" "fr-lyn" ];
      #   domain = "node.tchekda.dn42";
      # };
    };
  };

  users.users.aprl.extraGroups = [ "bird2" ];
}
