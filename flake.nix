{
  description = "Zuze OS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-test.url = "github:CutestNekoAqua/nixpkgs/sharkey";
    systems.url = "github:nix-systems/default-linux";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nur.url = "github:nix-community/NUR";
    attic.url = "github:zhaofengli/attic";
  };
  
  outputs = { self, nixpkgs, nixpkgs-test, systems, attic, nur, ... }: 
    let
      inherit (nixpkgs) lib;
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      systemBase = {
        modules = [
          # our base nix configs
          ./baseconf.nix
        ];
      };
      overlay-test = final: prev: {
        test = nixpkgs-test.legacyPackages.${prev.system};
      };
    in
  {
    packages = {
      default = self.nixosConfigurations.gnomeIso.config.system.build.isoImage;
      vm = self.nixosConfigurations.gnomeIso.config.system.build.vm;
    };

          hydraJobs =
        lib.mapAttrs (_: nixpkgs.lib.hydraJob) (
          let
            getBuildEntryPoint = name: nixosSystem:
              let
                cfg = if (lib.hasPrefix "iso" name) then
                  nixosSystem.config.system.build.isoImage
                else
                  nixosSystem.config.system.build.toplevel;
              in
              cfg;
          in
          lib.mapAttrs getBuildEntryPoint self.nixosConfigurations
          # NOTE: left here to have the code as reference if we need something like in the future, eg. on a stable update
          # // lib.mapAttrs' (hostname: nixosSystem: let
          #   hostname' = hostname + "-23-05";
          # in lib.nameValuePair
          #   hostname' # job display name
          #   (getBuildEntryPoint hostname' (nixosSystem' (nixosSystem.args // (with nixosSystem.args; {
          #     modules = modules ++ [
          #     #   {
          #     #     simd.enable = lib.mkForce true;
          #     #   }
          #     ];
          #     nixos = inputs.nixos-23-05;
          #   }))))
          # ) self.nixosConfigurations
        );
    
    nixosConfigurations = {
      gnomeIso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = systemBase.modules ++ [
          #"${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
          ./zuze-gnome.nix
        ];
        specialArgs = { inputs = self.inputs; };
      };
      tower = nixpkgs.lib.nixosSystem {
        specialArgs = { inputs = self.inputs; };
        modules = [
          #({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-test ]; })
          nur.nixosModules.nur
          ./system/tower/configuration.nix 
        ];
      };
      nonix = nixpkgs.lib.nixosSystem {
        specialArgs = { inputs = self.inputs; };
        modules = [
          nur.nixosModules.nur
          attic.nixosModules.atticd
          ./system/nonix/configuration.nix
        ];
      };
    };

    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [];
        };
      };

      nonix = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          buildOnTarget = true;
          targetHost = "nonix.sakamoto.pl";
        };
        imports = [
          nur.nixosModules.nur
          attic.nixosModules.atticd
          ./system/nonix/configuration.nix
        ];
      };
    };
  };
}
