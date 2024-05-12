{
  description = "Zuze OS";

  inputs = {
    nixpkgs.url = "github:auxolotl/nixpkgs/nixpkgs-unstable";
    nixpkgs-test.url = "github:CutestNekoAqua/nixpkgs/sharkey";
    
    systems.url = "github:nix-systems/default-linux";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nur.url = "github:nix-community/NUR";
    attic.url = "github:zhaofengli/attic";
    lysand-ap-layer.url = "github:lysand-org/lysand-ap-layer";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
      flake = false;
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    #extra-substituters = [
    #  "https://attic.fediverse.gay/prod"
    #];
    extra-trusted-public-keys = [
      "prod:UfOz2hPzocabclOzD2QWzsagOkX3pHSBZw8/tUEO9/g="
    ];
  };
  
  outputs = { self, nixpkgs, nixpkgs-test, home-manager, systems, attic, lix-module, nur, lysand-ap-layer, nixos-hardware, ... }: 
    let
      inherit (nixpkgs) lib;
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      systemBase = {
        modules = [
          # our base nix configs
          ./baseconf.nix
          lix-module.nixosModules.default
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
        modules = systemBase.modules ++ [
          #({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-test ]; })
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aprl = import ./system/users/aprl.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
          ./system/tower/configuration.nix 
        ];
      };
      cave = nixpkgs.lib.nixosSystem {
        specialArgs = { inputs = self.inputs; };
        modules = systemBase.modules ++ [
          #({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-test ]; })
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aprl = import ./system/users/aprl.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
          ./system/cave_johnson/configuration.nix 
          attic.nixosModules.atticd
          nixos-hardware.nixosModules.lenovo-thinkpad-t470s
        ];
      };
      nonix = nixpkgs.lib.nixosSystem {
        specialArgs = { inputs = self.inputs; };
        modules = systemBase.modules ++ [
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
        specialArgs = {
          inputs = self.inputs;
        };
      };

      tower = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          buildOnTarget = true;
          targetHost = null;
          allowLocalDeployment = true;
        };
        imports = systemBase.modules ++ [
          nur.nixosModules.nur
          attic.nixosModules.atticd
          ./system/tower/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aprl = import ./system/users/aprl.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };


      cave = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          buildOnTarget = true;
          targetHost = null;
          allowLocalDeployment = true;
        };
        imports = systemBase.modules ++ [
          nur.nixosModules.nur
          attic.nixosModules.atticd
          nixos-hardware.nixosModules.lenovo-thinkpad-t470s
          ./system/cave_johnson/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aprl = import ./system/users/aprl.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };

      nonix = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          buildOnTarget = true;
          targetHost = "sakamoto.pl";
          targetPort = 13370;
        };
        deployment.tags = [
          "infra-attic"
        ];
        imports = systemBase.modules ++ [
          nur.nixosModules.nur
          attic.nixosModules.atticd
          ./system/nonix/configuration.nix
        ];
      };

      moralitycore = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          targetHost = "morality.fediverse.gay";
          tags = [
            "web"
            "infra-ap"
            "infra-ls"
          ];
        };
        imports = [
          nur.nixosModules.nur
          attic.nixosModules.atticd
          lysand-ap-layer.nixosModules.default
          ./system/moralitycore/configuration.nix
        ];
      };
    };
  };
}
