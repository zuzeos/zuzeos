{ pkgs, lib, ... }:
let
  bgp = import peers/bgp.nix { };
in
{

  services = {
    bird-lg = {
      frontend = {
        enable = true;
        servers = [ "portalverse" ];
        proxyPort = 8992;
        domain = "lg.portalverse.versia.social";
      };
      proxy.enable = true;
      proxy.listenAddress = "45.150.123.22:8992";
    };

    bird = {
      enable = true;
      checkConfig = false;
      config = builtins.readFile ./bird.conf + lib.concatStrings (builtins.map
        (x: "
      protocol bgp ${x.name} from dnpeers {
        neighbor ${x.neigh} as ${x.as};
        ${if x.multi || x.v4 then "
        ipv4 {
                extended next hop on;
                import where dn42_import_filter(${x.link},25,34);
                export where dn42_export_filter(${x.link},25,34);
                import keep filtered;
        };
        " else ""}
        ${if x.multi || x.v6 then "
        ipv6 {
                extended next hop on;
                import where dn42_import_filter(${x.link},25,34);
                export where dn42_export_filter(${x.link},25,34);
                import keep filtered;
        };
        " else ""}
    }
        ")
        bgp.sessions) + bgp.extraConfig;
    };
  };

  users.users.aprl.extraGroups = [ "bird3" ];
}
