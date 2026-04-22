{ config, inputs, lib, pkgs, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
  ];

  isoImage.isoName = lib.mkForce "JesterLinux-1.0-${config.isoImage.isoBaseName}-${pkgs.stdenv.hostPlatform.system}.iso";

  networking.hostName = "jesterlinux";

  networking.domain = "";

  services.displayManager.autoLogin.user = lib.mkForce "jester";
  services.getty.autologinUser = lib.mkForce "jester";

  nix.settings.trusted-users = [ "jester" ];

  users.users.nixos.name = lib.mkForce "jester";
  nixpkgs.config.allowUnfree = true;
}
