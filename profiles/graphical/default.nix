{ pkgs, ... }: {
  imports = [
    ./gnome.nix
    ./onion.nix
    ./spotify.nix
    ./gaming
  ];

  users.users.aprl = {
    extraGroups = [ "wheel" "pipewire" "media" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      librewolf
      ungoogled-chromium
      webcord
      signal-desktop
      tree
      #ladybird
      thunderbird
      quasselClient
    ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "fluffychat-linux-1.25.1"
  ];

  services.pipewire = {
    raopOpenFirewall = true;
    extraConfig.pipewire = {
      "10-airplay"."context.modules" = [
        {
          name = "libpipewire-module-raop-discover";
        }
      ];
    };
  }; 

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
      prismlauncher
      nheko
      waydroid
      via
      lutris
    ];
    # media apps
    mediaPkgs = [
      mpv        # lightweight media player
      vlc        # encoder-rich media player
      firefox    # internet explorer
      system-config-printer # printer stuff
      communi
      inkscape
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
      skypeforlinux
      (zoom-us.overrideAttrs (attrs: {
        nativeBuildInputs = (attrs.nativeBuildInputs or []) ++ [ pkgs.bbe ];
        postFixup = ''
          cp $out/opt/zoom/zoom .
          bbe -e 's/\0manjaro\0/\0nixos\0\0\0/' < zoom > $out/opt/zoom/zoom
        '' + (attrs.postFixup or "") + ''
          sed -i 's|Exec=|Exec=env XDG_CURRENT_DESKTOP="gnome" |' $out/share/applications/Zoom.desktop
        '';
      }))
    ];
  in guiPkgs ++ mediaPkgs ++ libreChatPkgs ++ unfreeChatPkgs ++ [
    qemu
    bottles
    rustup
    mesa-demos
    yubikey-personalization
  ];

  fonts.packages = with pkgs; [
    dejavu_fonts open-sans
    roboto-serif roboto-mono
    ipafont
    libertinus andika
    helvetica-neue-lt-std
    liberation-sans-narrow
    andika
    sarabun-font oxygenfonts
    open-sans work-sans
    fira fira-mono fira-code
    rictydiminished-with-firacode
    fira-go
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "Source Code Pro" "DejaVu Sans Mono" ]; # TODO might not work
      sansSerif = [ "Liberation Sans" ];
      serif = [ "Liberation Serif" ];
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };


  programs = {
    zsh.enable = true;
    direnv.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  
  virtualisation.waydroid.enable = true;

  hardware.keyboard.qmk.enable = true;

  services.flatpak.enable = true;
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
  services.pulseaudio.enable = false;

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];
    enable32Bit = true;
  };
}
