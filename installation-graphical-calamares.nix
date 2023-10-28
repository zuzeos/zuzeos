# adds calamares installer to graphical install derivation
{ pkgs, ... }:
let
  calamares-nixos-autostart = pkgs.makeAutostartItem {
    name = "io.calamares.calamares";
    package = pkgs.calamares-nixos;
  };
in
{
  imports = [ ./installer-graphical.nix ];
  environment.systemPackages = with pkgs; [
    libsForQt5.kpmcore
    calamares-nixos
    calamares-nixos-autostart
    calamares-nixos-extensions
    # get list for locales
    glibcLocales
  ];

  # Support choosing any locale
  i18n.supportedLocales = [ "all" ];
}
