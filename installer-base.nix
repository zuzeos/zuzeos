{ lib, pkgs, ... }:
with lib;
{
  imports = [
    ./iso-image.nix

    # profiles of basic install CD
    ./profiles/all-hardware.nix
    ./profiles/base.nix
    ./profiles/installation-device.nix
  ];

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    })
  '';

  # for HiDPI displays
  console.packages = options.console.packages.default ++ [ pkgs.terminus_font ];

  isoImage = {
    isoName = "Zuse23.11.1-${config.isoImage.isoBaseName}-${pkgs.stdenv.hostPlatform.system}.iso";
    makeEfiBootable = true;
    makeUsbBootable = true;
  };

  # TODO add boot postBootCommands

  boot.loader.grub.memtest86.enable = true;

  swapDevices = mkImageMediaOverride [];
  fileSystems = mkImageMediaOverride config.lib.isoFileSystems;

  system.stateVersion = mkDefault trivial.release;
  
}
