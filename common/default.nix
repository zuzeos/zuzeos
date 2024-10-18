{ pkgs, ... }: {

  imports = [
    ./users
    ./codename.nix
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      max-jobs = "auto";
      sandbox = true;
      experimental-features = [ "nix-command" "flakes" ];
      builders-use-substitutes = true;
      allowed-uris = [
        "github:"
        "git+https://github.com/"
        "git+ssh://github.com/"
        "https://github.com/"
        "https://user-images.githubusercontent.com/"
        "https://api.github.com/"
      ];
      substituters = [
        /*"https://attic.fediverse.gay/prod"*/
        "https://cache.nixos.org"
        "https://cache.kyouma.net"
      ];
      trusted-public-keys = [
        "prod:UfOz2hPzocabclOzD2QWzsagOkX3pHSBZw8/tUEO9/g="
        "cache.kyouma.net:Frjwu4q1rnwE/MnSTmX9yx86GNA/z3p/oElGvucLiZg="
      ];
    };
    distributedBuilds = true;
  };
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "olm-3.2.16"
      "jitsi-meet-1.0.8043"
      "electron"
    ];
  };

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

    environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget

    colmena

    nano              # beginner friendly editor
    smartmontools     # check disk state
    stow              # dotfile management
    wirelesstools     # iwlist (wifi scan)
    gitFull           # git with send-email
    catgirl           # IRC terminal client
    curl              # transfer data to/from a URL
    binutils          # debugging binary files
    dos2unix          # text file conversion
    file              # file information
    htop              # top replacement
    ncdu              # disk size checker
    nmap              # stats about clients in the network
    netcat-openbsd    # swiss army knife of networking
    #man-pages          # system manpages (not included by default)
    mkpasswd          # UNIX password creator
    lr                # list recursively, ls & find replacement
    ripgrep           # file content searcher, > ag > ack > grep
    rsync             # file syncing tool
    strace            # tracing syscalls
    tmux              # detachable terminal multiplexer
    traceroute        # trace ip routes
    wget              # the other URL file fetcher
    vim               # slight improvement over vi
    #neovim            # slight improvement over vim
    helix             # vi but recoded in rust
    xe                # xargs with a modern interface
    nil               # Nix language server
    rust-analyzer     # Rust language server
    samba
    gh                # github cli
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        colorscheme habamax
      '';

      packages.packages = {
        start = [
          pkgs.vimPlugins.nerdtree
        ];
      };
    };
  };

  programs = {
    direnv.enable = true;
    mtr.enable = true;
    fish.enable = true;
  };

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5; # <5% free
  };

  services.journald.extraConfig = "SystemMaxUse=500M";

  system.stateVersion = "24.05";
}