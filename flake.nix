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
  outputs = { self, nixpkgs, nixpkgs-test, systems, nixos-hardware, ... }@inputs: let
    flib = import ./lib inputs;
  in {
    hosts = flib.mapHosts {};
    packages = {
      x86_64-linux.default = self.nixosConfigurations._zuze-gnome.config.system.build.isoImage;
      x86_64-linux.vm = self.nixosConfigurations._zuze-gnome.config.system.build.vm;
    };

    hydraJobs = { 
      inherit (self) packages;
      nixosConfigurations = flib.mapHydraHosts self.nixosConfigurations;
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
    };
    
    nixosConfigurations = flib.mapNixosCfg { 
      # non standard system declarations go here and will be
      # merged recursively with the auto generated config
      # therefore updating parameters of generated system
      # declarations is also possible :3
    };

    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [];
        };
        specialArgs = { inherit inputs; };
      };

      tower = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          buildOnTarget = true;
          targetHost = null;
          allowLocalDeployment = true;
        };
        imports = [
          ./system/tower/configuration.nix
        ];
      };


      cave = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          buildOnTarget = true;
          targetHost = null;
          allowLocalDeployment = true;
        };
        imports = [
          ./system/cave_johnson/configuration.nix
        ];
      };

      ajx2407 = { name, nodes, pkgs, ... }: {
        time.timeZone = "Europe/Berlin";
        deployment = {
          buildOnTarget = true;
          targetHost = null;
          allowLocalDeployment = true;
        };
        imports = [
          ./system/p_body/configuration.nix
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
        imports = [
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
          ./system/spacecore/configuration.nix
        ];
      };
    };
  };
}
