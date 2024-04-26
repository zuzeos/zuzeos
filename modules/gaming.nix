{ pkgs, lib, inputs, ... }:
{
  imports = [
    gaming/gamemoderun.nix
  ];
  environment.systemPackages = [
    pkgs.mangohud
  ]; 
}
