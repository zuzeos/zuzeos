{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  users.users.aprl = {
    isNormalUser = true;
    description = "Aprl System (April John)";
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$y$j9T$yn9Iqo4bKMoy4WYRUXTRA/$ICI2Z6yAh4.8gyApfzEl.gwwJOAXWrjSl3PVzKqk12.";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.aprl = {
    home.username = "aprl";
    home.homeDirectory = "/home/aprl";

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "23.11";
  };
}
