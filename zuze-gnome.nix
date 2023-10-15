# This module defines a instalation CD that contains GNOME

{ pkgs, ... }:

{
  imports = [ ./installation-graphical-calamares.nix ];
  isoImage.edition = "gnome";

  # wayland scaling fixes for calamares
  enviroment.variables = {
    QT_QPA_PLATFORM = "$([[ $XDG_SESSION_TYPE = \"wayland\" ]] && echo \"wayland\")";
  };

  services.xserver = {
    desktopManager.gnome = {
      enable = true;

      favoriteAppsOverride = ''
        [org.gnome.shell]
        favorite-apps=[ 'io.calamares.calamares.desktop', 'firefox.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'gparted.desktop', 'nixos-manual.desktop' ]
      '';

      extraGSettingsOverrides = ''
        [org.gnome.shell]
        welcome-dialog-last-shown-version='999999999'
        [org.gnome.desktop.session]
        idle-delay=0
        [org.gnome.settings-daemon.plugins.power]
        sleep-inactive-ac-type='nothing'
        sleep-inactive-battery-type='nothing'
      '';

      extraGSettingsOverridePackages = [
        pkgs.gnome.gnome-settings-daemon
      ];
    };

    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
      };
      autoLogin = {
        enable = true;
        user = "zuze";
      };
    };
  };
}
