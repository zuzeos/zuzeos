 {pkgs, lib, ...}: {


  nix.settings.sandbox = true;

  nix.settings.max-jobs = "auto";

  boot.tmp.cleanOnBoot = true;

  

    # the kernel OOM is not good enough without swap,
    # and I don’t like swap. This kills the most hoggy
    # processes when the system goes under a free space limit
    services.earlyoom = {
      enable = true;
      freeMemThreshold = 5; # <5% free
    };

    # bounded journal size
    services.journald.extraConfig = "SystemMaxUse=500M";

   programs.bash = {
      interactiveShellInit = ''
        alias use='nix-shell -p'
        alias switch-config='nixos-rebuild switch'
        alias tad='tmux attach -d'
        alias gs='git status'

        # search recursively in cwd for file glob (insensitive)
        findia () { find -iname "*''${*}*"; }
        # like findia, but first argument is directory
        findian () { path="$1"; shift; find $path -iname "*''${*}*"; }
        # like findian, but searches whole filepath
        findiap () { path="$1"; shift; find $path -ipame "*''${*}*"; }
      '';
  };

  fonts.fonts = with pkgs; [
    dejavu_fonts open-sans
    roboto-serif roboto-mono
    nerdfonts ipafont
    libertinus andika
    helvetica-neue-lt-std
    liberation-sans-narrow
    andika joypixels
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

  enviroment.sessionVariables = {
    # EDITOR = "${myPkgs.vim}/bin/vim";
  };

  enviroment.systemPackages = with pkgs;
  let
      # of utmost necessity for me to function
      basePkgs = [
        smartmontools     # check disk state
        stow              # dotfile management
        wirelesstools     # iwlist (wifi scan)
        gitFull           # git with send-email
        catgirl

        
        curl              # transfer data to/from a URL
        binutils          # debugging binary files
        dos2unix          # text file conversion
        file              # file information
        htop              # top replacement
        ncdu              # disk size checker
        nmap              # stats about clients in the network
        man-pages          # system manpages (not included by default)
        mkpasswd          # UNIX password creator
        lr                # list recursively, ls & find replacement
        ripgrep           # file content searcher, > ag > ack > grep
        rsync             # file syncing tool
        strace            # tracing syscalls
        tmux              # detachable terminal multiplexer
        traceroute        # trace ip routes
        wget              # the other URL file fetcher
        vim        # slight improvement over vi
        neovim            # slight improvement over vim
        xe                # xargs with a modern interface
      ];
      # minimal set of gui applications
      guiPkgs = [
        dmenu             # minimal launcher
        alacritty
        helix
        easyeffects
        htop
      ];
      # media apps
      mediaPkgs = [
        telegram-desktop
        mattermost
        firefox
        discord
        vscode
        element-web
        dino
        communi
      ];
    in basePkgs ++ guiPkgs ++ mediaPkgs;

  programs.fish.enable = true;
  
}
