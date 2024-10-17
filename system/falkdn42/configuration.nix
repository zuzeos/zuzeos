
{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./disko-config.nix
      ../../modules/dn42de
    ];

  boot.loader.grub.enable = true;

  networking.hostName = "falkdn42";

  zramSwap.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPKL1+FX6pt3EasE9ZIb9Qg+LvFVagAVi2Uy9X2E90n aprl@acab.dev"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxsX+lEWkHZt9NOvn9yYFP0Z++186LY4b97C4mwj/f2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpyVefbZLkNVNzdSIlO6x6JohHE1snoHiUB3Qdvl5I2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSLlsbQFnRrwR/Vn9v+QuxEpa/vVDoLSDcA/TEGsxFn c3d2@ungoogled-chromebook"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0v3tUBNEUxfoOQBFb+N2DUBQDay0iFggUWa9Nd+BtFLOKkz+RRto3eBF0ZiJZVUxv/hLb8m2s45hcMw8agwuPrXMe5085T1fzkvPdKAPZdsT/cCmBi1OsoLjAKBFIdM4lcV0A2cca8hip+/ZPpjFPUWx73/672gAPHU7co7fP8+8CSf9dx+WIeLx3yaYHYZ/th3dB5auX3VjOazS8MojsAorwTUeBoPamHQ5dFeNafhFUL/hhtGkUI1cNHUn3bJd2V7AKTW3UglK7hVgMJPrzVS31OlpcJEf6S5XgKTWdOSwubn1bs5Lt6YYRDU24NV6CGrwKgCJSRxzNMLwpnFKiSXpO8FzkqWHYWyju141hQcFF31aZIV+7YcwEt5ZukLjFOpVtpbSXvJYigOUzGi34P3/OAGshDXjTQjvM8GIir49gx3b2Nwhg0z4UHBkAKZvDDFPHDMJoclvnhITojaAojfC9zmMCO5ZaEsk8yv7c/lWQumzRpfldWF4mwHvhD5kTADbhRdO7WTdX7AaiAYINooToeWKjFe2wn3rFubPUppptqtP03mmvs7vhhgnEVBbGZRJK3GTVk1XcsfF9rDKzewSa+wb4LsBoZtFRhc8cJqHGlKWSNk7dQ04B1atPyNLKGpGoo/UIPxyZ6bSqFVxY3nhz46VZ6z8XWI48z0/fRQ=="
  ];

  users.users.aprl.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPKL1+FX6pt3EasE9ZIb9Qg+LvFVagAVi2Uy9X2E90n aprl@acab.dev"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxsX+lEWkHZt9NOvn9yYFP0Z++186LY4b97C4mwj/f2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpyVefbZLkNVNzdSIlO6x6JohHE1snoHiUB3Qdvl5I2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSLlsbQFnRrwR/Vn9v+QuxEpa/vVDoLSDcA/TEGsxFn c3d2@ungoogled-chromebook"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0v3tUBNEUxfoOQBFb+N2DUBQDay0iFggUWa9Nd+BtFLOKkz+RRto3eBF0ZiJZVUxv/hLb8m2s45hcMw8agwuPrXMe5085T1fzkvPdKAPZdsT/cCmBi1OsoLjAKBFIdM4lcV0A2cca8hip+/ZPpjFPUWx73/672gAPHU7co7fP8+8CSf9dx+WIeLx3yaYHYZ/th3dB5auX3VjOazS8MojsAorwTUeBoPamHQ5dFeNafhFUL/hhtGkUI1cNHUn3bJd2V7AKTW3UglK7hVgMJPrzVS31OlpcJEf6S5XgKTWdOSwubn1bs5Lt6YYRDU24NV6CGrwKgCJSRxzNMLwpnFKiSXpO8FzkqWHYWyju141hQcFF31aZIV+7YcwEt5ZukLjFOpVtpbSXvJYigOUzGi34P3/OAGshDXjTQjvM8GIir49gx3b2Nwhg0z4UHBkAKZvDDFPHDMJoclvnhITojaAojfC9zmMCO5ZaEsk8yv7c/lWQumzRpfldWF4mwHvhD5kTADbhRdO7WTdX7AaiAYINooToeWKjFe2wn3rFubPUppptqtP03mmvs7vhhgnEVBbGZRJK3GTVk1XcsfF9rDKzewSa+wb4LsBoZtFRhc8cJqHGlKWSNk7dQ04B1atPyNLKGpGoo/UIPxyZ6bSqFVxY3nhz46VZ6z8XWI48z0/fRQ=="
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
      ];
      trusted-public-keys = [
        "prod:UfOz2hPzocabclOzD2QWzsagOkX3pHSBZw8/tUEO9/g="
      ];
    };
    distributedBuilds = true;
  };

  # allow non FOSS pkgs
  nixpkgs.config.allowUnfree = true;

  boot = {
    # clean tmp directory on boot
    tmp.cleanOnBoot = true;
  };

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5; # <5% free
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


  services.journald.extraConfig = "SystemMaxUse=500M";

  services.openssh.enable = true;

  users.users.aprl = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$y$j9T$yn9Iqo4bKMoy4WYRUXTRA/$ICI2Z6yAh4.8gyApfzEl.gwwJOAXWrjSl3PVzKqk12.";
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
  };

  virtualisation.docker.enable = true;

  networking.domain = "aprilthe.pink";

  networking.firewall.allowedTCPPorts = [ 80 443 22 ];

  services.netbox = {
    enable = true;
    secretKeyFile = "/var/lib/netbox/secret-key-file";
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedZstdSettings = true;
    recommendedBrotliSettings = true;
    clientMaxBodySize = "25m";

    user = "netbox";

    virtualHosts."netbox.${config.networking.fqdn}" = {
      locations = {
        "/" = {
          proxyPass = "http://[::1]:8001";
          # proxyPass = "http://${config.services.netbox.listenAddress}:${config.services.netbox.port}";
        };
        "/static/" = { alias = "${config.services.netbox.dataDir}/static/"; };
      };
      forceSSL = true;
      enableACME = true;
      serverName = "netbox.${config.networking.fqdn}";
    };
  };

  security.acme = {
    defaults.email = "acme@${config.networking.domain}";
    acceptTerms = true;
  };

  system.stateVersion = "24.05";
}
