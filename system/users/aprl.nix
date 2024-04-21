{ config, pkgs, ... }:

{
  home.username = "aprl";
  home.homeDirectory = "/home/aprl";

  xdg.desktopEntries = {
    i2p-browser = {
      name = "i2p Browser";
      genericName = "Web Browser";
      exec = "${pkgs.librewolf}/bin/librewolf -p i2p";
    };
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
