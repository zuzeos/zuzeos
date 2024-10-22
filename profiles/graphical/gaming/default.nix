{ pkgs, ... }: {
  imports = [
    ./gamemoderun.nix
  ];
  environment.systemPackages = [
    pkgs.mangohud
  ]; 
}
