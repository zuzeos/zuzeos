# graphical installation CD
{ lib, pkgs, ...}:
with lib;
{
  imports = [ ./installer-base.nix ];

  services.xserver.enable = true;
  networking.networkmanager.enable = true;
  networking.wireless.enable = mkImageMediaOverride false;
  powerManagement.enable = true;

  # VM guest additions to improve host-guest interaction
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  virtualisation.vmware.guest.enable = pkgs.stdenv.hostPlatform.isx86;
  virtualisation.hypervGuest.enable = true;
  services.xe-guest-utilities.enable = pkgs.stdenv.hostPlatform.isx86;

  virtualisation.virtualbox.guest.enable = false;

  # Enable plymouth
  boot.plymouth.enable = true;

  enviroment.defaultPackages = with pkgs; [
    gparted
    vim nano
    git rsync
    firefox
    glxinfo
  ];
  
}
