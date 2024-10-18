 {pkgs, lib, imports, ...}: {

  imports = [
    ./common/codename.nix
  ];

  services.power-profiles-daemon.enable = false;
  
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

  environment.sessionVariables = {
    EDITOR = "${pkgs.nano}/bin/nano";
  };

  environment.systemPackages = with pkgs;
  let
    # Distro specific rice
    zuzeRicePkgs = [
      hyfetch           # superior queer fetch script
      zsh-you-should-use
      any-nix-shell
      zsh-history
      zsh-vi-mode
      oh-my-zsh
      oh-my-fish
    ];
    # Programming languages
    progPkgs = [
      #pypy3
      python3              # Python 3
      lua5_4_compat              # Lua 5.4
      lua54Packages.luarocks-nix # Lua package manager
      kotlin                     # Kotlin dev env
      openjdk17-bootstrap        # Java 17
    ];
    # minimal set of gui applications
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
    in guiPkgs ++ mediaPkgs ++ libreChatPkgs ++ unfreeChatPkgs
                ++ progPkgs ++ zuzeRicePkgs;

  programs = {
    zsh.enable = true;
    direnv.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  networking = {
    networkmanager = { # easiest to use; most distros use this
      enable = true;
    };

    # Routers are supposed to handle firewall on local networks
    firewall.enable = false;
  };

  documentation.man.enable = false;

  services = {
    # printing setup
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
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
    # default touchpad support
    libinput.enable = true;
    
    openssh.enable = true;
  };

  virtualisation.docker.enable = true;

  # use pipewire instead of pulse
  security = {
    rtkit.enable = true;
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
  hardware.pulseaudio.enable = false;

  services.fwupd.enable = true;
  
  system.nixos.tags = [
    "ZuzeOS-alpha"
  ];
  system.nixos.distroName = "ZuzeOS";
}
