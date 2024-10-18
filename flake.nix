{
  description = "Zuze OS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-test.url = "github:CutestNekoAqua/nixpkgs/sharkey";
    
    systems.url = "github:nix-systems/default-linux";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    jeezyvim.url = "github:LGUG2Z/JeezyVim";
  };

  nixConfig = {
    extra-substituters = [
    #  "https://attic.fediverse.gay/prod"
      "https://cache.kyouma.net"
    ];
    extra-trusted-public-keys = [
    #  "prod:UfOz2hPzocabclOzD2QWzsagOkX3pHSBZw8/tUEO9/g="
      "cache.kyouma.net:Frjwu4q1rnwE/MnSTmX9yx86GNA/z3p/oElGvucLiZg="
    ];
  };
  outputs = { self, nixpkgs, nixpkgs-test, home-manager, systems, lix-module, nur, nixos-hardware, disko, nix-index-database, ... }@inputs: let
    inherit (nixpkgs) lib;
    eachSystem = lib.genAttrs (import systems);
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
  in {
    packages = {
      x86_64-linux.default = self.nixosConfigurations.gnomeIso.config.system.build.isoImage;
      x86_64-linux.vm = self.nixosConfigurations.gnomeIso.config.system.build.vm;
      aarch64-linux.default = self.nixosConfigurations.gnomeIso.config.system.build.isoImage;
      aarch64-linux.vm = self.nixosConfigurations.gnomeIso.config.system.build.vm;
    };

    hydraJobs = { 
      inherit (self) packages;
      nixosConfigurations = let
        getBuildEntryPoint = name: nixosSystem:
          if (lib.hasPrefix "iso" name) then
            nixosSystem.config.system.build.isoImage
          else
            nixosSystem.config.system.build.toplevel;
      in (
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
    };
    
    nixosConfigurations = {
      gnomeIso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = systemBase.modules ++ [
          #"${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
          ./system/_zuze-gnome/default.nix
        ];
        specialArgs = { inherit inputs; };
      };
      falkdn42 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/falkdn42/configuration.nix
          disko.nixosModules.disko
        ];
      };
      heldn42 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/heldn42/configuration.nix
          disko.nixosModules.disko
        ];
      };
      singdn42 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/singdn42/configuration.nix
          disko.nixosModules.disko
        ];
      };
      ashdn42 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/ashdn42/configuration.nix
          disko.nixosModules.disko
        ];
      };
      tower = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = systemBase.modules ++ [
          #({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-test ]; })
          nur.nixosModules.nur
          nix-index-database.nixosModules.nix-index
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
      moralitycore = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = systemBase.modules ++ [
          disko.nixosModules.disko
          nur.nixosModules.nur
          nix-index-database.nixosModules.nix-index
          ./system/moralitycore/configuration.nix
        ];
      };
      glados = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = systemBase.modules ++ [
          disko.nixosModules.disko
          nur.nixosModules.nur
          nix-index-database.nixosModules.nix-index
          ./system/glados/configuration.nix
        ];
      };
      spacecore = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = systemBase.modules ++ [
          disko.nixosModules.disko
          nur.nixosModules.nur
          nix-index-database.nixosModules.nix-index
          ./system/spacecore/configuration.nix
        ];
      };
      cave = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = systemBase.modules ++ [
          #({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-test ]; })
          nur.nixosModules.nur
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aprl = import ./system/users/aprl.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
          ./system/cave_johnson/configuration.nix 
          nixos-hardware.nixosModules.lenovo-thinkpad-t470s
        ];
      };
      ajx2407 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = systemBase.modules ++ [
          #({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-test ]; })
          nur.nixosModules.nur
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aprl = import ./system/users/aprl.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
          ./system/p_body/configuration.nix 
          #nixos-hardware.nixosModules.lenovo-thinkpad-t470s
        ];
      };
      
      nonix = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = systemBase.modules ++ [
          nur.nixosModules.nur
          nix-index-database.nixosModules.nix-index
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
          inherit inputs;
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
          { nixpkgs.overlays = [ nur.overlay ]; }
          ({ pkgs, ... }:
            let
              nur-no-pkgs = import nur {
                nurpkgs = import nixpkgs { system = "x86_64-linux"; };
              };
            in {
              imports = [ nur-no-pkgs.repos.spitzeqc.modules.yacy ];
              services.yacy.enable = true;
            })
          ./system/tower/configuration.nix
          nix-index-database.nixosModules.nix-index
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
          nixos-hardware.nixosModules.lenovo-thinkpad-t470s
          ./system/cave_johnson/configuration.nix
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aprl = import ./system/users/aprl.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };

      ajx2407 = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          buildOnTarget = true;
          targetHost = null;
          allowLocalDeployment = true;
        };
        imports = systemBase.modules ++ [
          nur.nixosModules.nur
          #nixos-hardware.nixosModules.lenovo-thinkpad-t470s
          ./system/p_body/configuration.nix
          nix-index-database.nixosModules.nix-index
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
          nix-index-database.nixosModules.nix-index
          ./system/nonix/configuration.nix
        ];
      };

      ashdn42 = { name, nodes, pkgs, ... }: {
        time.timeZone = "America/New_York";
        deployment = {
          buildOnTarget = true;
          targetHost = "5.161.236.38";
          targetPort = 22;
        };
        deployment.tags = [
          "dn42de"
        ];
        imports = [
          nur.nixosModules.nur
          disko.nixosModules.disko
          nix-index-database.nixosModules.nix-index
          ./system/ashdn42/configuration.nix
        ];
      };

      singdn42 = { name, nodes, pkgs, ... }: {
        time.timeZone = "Asia/Singapore";
        deployment = {
          buildOnTarget = true;
          targetHost = "5.223.43.218";
          targetPort = 22;
        };
        deployment.tags = [
          "dn42de"
        ];
        imports = [
          nur.nixosModules.nur
          disko.nixosModules.disko
          nix-index-database.nixosModules.nix-index
          ./system/singdn42/configuration.nix
        ];
      };

      heldn42 = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          buildOnTarget = true;
          targetHost = "37.27.9.168";
          targetPort = 22;
        };
        deployment.tags = [
          "dn42de"
        ];
        imports = [
          nur.nixosModules.nur
          disko.nixosModules.disko
          nix-index-database.nixosModules.nix-index
          ./system/heldn42/configuration.nix
        ];
      };

      falkdn42 = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          buildOnTarget = true;
          targetHost = "188.245.199.114";
          targetPort = 22;
        };
        deployment.tags = [
          "dn42de"
        ];
        imports = [
          nur.nixosModules.nur
          disko.nixosModules.disko
          nix-index-database.nixosModules.nix-index
          ./system/falkdn42/configuration.nix
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
          disko.nixosModules.disko
          nur.nixosModules.nur
          nix-index-database.nixosModules.nix-index
          ./system/moralitycore/configuration.nix
        ];
      };

      glados = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          targetHost = "fedinet.org";
          tags = [
            "web"
            "infra-mm"
          ];
        };
        imports = [
          disko.nixosModules.disko
          nur.nixosModules.nur
          nix-index-database.nixosModules.nix-index
          ./system/glados/configuration.nix
        ];
      };

      spacecore = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          buildOnTarget = true;
          targetHost = "192.168.69.126"; # TODO
          tags = [
            "web"
            "infra-local"
          ];
        };
        imports = [
          disko.nixosModules.disko
          nur.nixosModules.nur
          nix-index-database.nixosModules.nix-index
          ./system/spacecore/configuration.nix
        ];
      };
    };
  };
}
