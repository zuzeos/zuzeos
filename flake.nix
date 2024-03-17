{
  description = "Zuze OS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-test.url = "github:CutestNekoAqua/nixpkgs/sharkey";
    systems.url = "github:nix-systems/default-linux";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nur.url = "github:nix-community/NUR";
  };
  
  outputs = { self, nixpkgs, nixpkgs-test, systems, nur, ... }: 
    let
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

    hydraJobs = {
      inherit (self)
        packages;
    };
    
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
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-test ]; })
          nur.nixosModules.nur
          ./system/tower/configuration.nix 
        ];
      };
    };
  };
}
