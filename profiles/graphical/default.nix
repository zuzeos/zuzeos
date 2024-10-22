{ pkgs, ... }: {
  imports = [
    ./gnome.nix
    ./onion.nix
    ./spotify.nix
    ./gaming
  ];
  home-manager.users.aprl = {
    xdg.desktopEntries = {
      i2p-browser = {
        name = "i2p Browser";
        genericName = "Web Browser";
        exec = "${pkgs.librewolf}/bin/librewolf -p i2p";
      };
    };
  };

  environment.systemPackages = with pkgs; let
    guiPkgs = [
      gtklp             # CUPS gui
      dmenu             # minimal launcher
      alacritty         # rust based terminal emulator
      kitty             # another, easy configurable terminal emulator
      helvum            # GTK patchbay for pipewire
      easyeffects       # pipewire sound tuner
      htop              # system monitor
      vscode            # graphical text editor
      libreoffice-fresh # fresh and spicy office tools
    ];
    # media apps
    mediaPkgs = [
      mpv        # lightweight media player
      vlc        # encoder-rich media player
      firefox    # internet explorer
      system-config-printer # printer stuff
      communi
    ];
    # FOSS based chat apps
    libreChatPkgs = [
      mattermost-desktop  # libre slack alternative
      element-web         # feature-rich matrix client
      dino                # GTK-based XMPP messenger
    ];
    # Chat apps with proprietary components
    unfreeChatPkgs = [
      telegram-desktop # most popular instant-messenger in the IT world
      discord          # IRC-like proprietary chat service
    ];
  in guiPkgs ++ mediaPkgs ++ libreChatPkgs ++ unfreeChatPkgs;

  fonts.packages = with pkgs; [
    dejavu_fonts open-sans
    roboto-serif roboto-mono
    nerdfonts ipafont
    libertinus andika
    helvetica-neue-lt-std
    liberation-sans-narrow
    andika
    sarabun-font oxygenfonts
    open-sans work-sans
    fira fira-mono fira-code
    fira-code-nerdfont
    rictydiminished-with-firacode
    fira-go
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "Source Code Pro" "DejaVu Sans Mono" ]; # TODO might not work
      sansSerif = [ "Liberation Sans" ];
      serif = [ "Liberation Serif" ];
    };
  };

  programs = {
    zsh.enable = true;
    direnv.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    socketActivation = true;
    systemWide = true;
  };
  services.libinput.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplip
      postscript-lexmark
      splix
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
      cnijfilter2
    ];
  };
  hardware.pulseaudio.enable = false;
}
