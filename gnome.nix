{ pkgs, ... }: {
  services = {
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
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
}
