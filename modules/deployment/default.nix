{ lib, ... }: let 
  inherit (lib) mkOption types;
in {
  options.zuze.deployment = {
    tags = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "colmena deployment tags";
    };
    targetHost = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "colmena target host";
    };
    targetPort = mkOption {
      type = with types; port;
      default = 22;
      description = "colmena target port";
    };
  };
}
