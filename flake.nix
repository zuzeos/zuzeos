{
  description = "Zuze OS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-test.url = "github:CutestNekoAqua/nixpkgs/sharkey";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default-linux";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    jeezyvim.url = "github:LGUG2Z/JeezyVim";
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
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

  outputs = { self, nixpkgs, nixpkgs-test, systems, nixos-hardware, nixpkgs-stable, ... }@inputs: let
    flib = import ./lib inputs;
  in {
    hosts = flib.mapHosts {};

    colmena = flib.mapColmenaCfg {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [];
        };
        specialArgs = { inherit inputs; };
      };
    };
    
    nixosConfigurations = flib.mapNixosCfg { 
      # non standard system declarations go here and will be
      # merged recursively with the auto generated config
      # therefore updating parameters of generated system
      # declarations is also possible :3
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

    packages = {
      x86_64-linux.default = self.nixosConfigurations._zuze-gnome.config.system.build.isoImage;
      x86_64-linux.vm = self.nixosConfigurations._zuze-gnome.config.system.build.vm;
    };
  };
}
