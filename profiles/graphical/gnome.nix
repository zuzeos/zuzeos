{ pkgs, ... }: {

  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-curses;

  services = {
    udev.packages = with pkgs; [ gnome-settings-daemon ];
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      desktopManager.gnome.enable = true;
      excludePackages = with pkgs; [ xterm ];
    };
  };
  system.nixos.tags = [
    "gnome"
  ];
}
