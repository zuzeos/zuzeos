{ self, nixpkgs, ... }@inputs: let
  mapDir = dir: builtins.attrNames (nixpkgs.lib.filterAttrs (name: type: type == "directory") (
    builtins.readDir ../${dir}));

  genColmenaCfg = name: host: {
    deployment = {
      allowLocalDeployment = builtins.any (hostName: hostName == name) [ "tower" "cave" "p_body" "ajx2407" ];
      buildOnTarget = true;
      targetHost = nixpkgs.lib.findFirst (el: el != null) host.config.networking.fqdn [ host.config.zuze.deployment.targetHost ];
      targetPort = host.config.zuze.deployment.targetPort;
      #targetUser = null;
      tags = host.config.zuze.deployment.tags;
    };
    imports = host._module.args.modules;
    nixpkgs.system = host.config.nixpkgs.system;
  };

  genNixosCfg = {
    hostname,
    system ? "x86_64-linux"
  }: 
  nixpkgs.lib.nixosSystem {
    system = system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/${hostname}/configuration.nix
      ../modules
      ({ ... }: {
        networking.hostName = nixpkgs.lib.mkDefault hostname;
        nixpkgs.overlays = [ ];
        nixpkgs.hostPlatform.system = system;
      })
    ];
  };
  getBuildEntryPoint = name: nixosSystem:
    if (nixpkgs.lib.hasPrefix "iso" name) then
      nixosSystem.config.system.build.isoImage
    else
      nixosSystem.config.system.build.toplevel;

in {
  mapHosts = hostCfg: nixpkgs.lib.recursiveUpdate (
    nixpkgs.lib.genAttrs (mapDir "system") (host: { hostname = host; })) hostCfg;

  mapColmenaCfg = extraColmenaCfg: nixpkgs.lib.recursiveUpdate (
    builtins.mapAttrs (genColmenaCfg) self.nixosConfigurations) extraColmenaCfg;

  mapNixosCfg = extraNixosCfg: nixpkgs.lib.recursiveUpdate (builtins.mapAttrs (_: value:
    genNixosCfg value) self.hosts) extraNixosCfg;

  mapHydraHosts = hosts: builtins.mapAttrs (getBuildEntryPoint) hosts;
}
