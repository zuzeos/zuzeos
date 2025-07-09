{pkgs, ...}: let
  callPackage = pkgs.callPackage;
in {
  nixpkgs.overlays = [(final: prev: {
    wazuh-agent = callPackage ./wazuh.nix {};
  })];
}