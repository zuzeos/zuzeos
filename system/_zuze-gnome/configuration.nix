{ config, inputs, lib, pkgs, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
  ];

  isoImage.isoName = lib.mkForce "Zuse23.11.1-${config.isoImage.isoBaseName}-${pkgs.stdenv.hostPlatform.system}.iso";

  networking.hostName = "zuzeos";

  networking.domain = "";

  services.displayManager.autoLogin.user = lib.mkForce "zuze";
  services.getty.autologinUser = lib.mkForce "zuze";

  nix.settings.trusted-users = [ "zuze" ];

  users.users.nixos.name = lib.mkForce "zuze";
  nixpkgs.config.allowUnfree = true;
}
