# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../baseconf.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  networking.hostName = "sakanixno"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aprl = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDVNo871p97NTefP52KYiwuch+FaVScxvcFd9fg0yykySTq7Y5JsxrJQgTnox/oDa0O87OyHD/GHQljAXkqiHpDkExbiGjDmGXJSKReKH061F4FqBnDIwYRzUu9Cxjl4MNqsU0RqLaz4+F42c/L7GROQwjEPUb8JHThRiI5FJnDvvB+oBLBxeyQA4v3O4i8DaDQayTr/XB+aSlhNwKrb6cjjL93AHT1uE53yY5jn4kZX+RiPQhH7rvt9N6E4Yr3CG6nUgRCUS0L66d9yfrq0XAbAVk9F+viV7Nk9qy4MWHtXZ4h0qUlzrGALPgGsCGiLGd4NvEgeCcV4nvxdmevxTSdKlJP75xlmlLVXGyhqCZkTsxm/png2UvDl+p0pLyrgNaNoXPdE0Jbv7C28WX36Nast1QFSMUhexzuOx8OgaOioeXVfK98AouqWb58iPBCvgreUIH/gJhZcnlB/Foo1KSO+fJNH8hAsLH7w0mnKyHhJjkrjjwUqsnpepB3SOLfZTE="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMPg5zmlQRhBxKeWRhpt5ajmxlIHvF43TI+9rIi5O6Lw"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/RmFnel8pcZT9nh7EAfKfAekt3BoEXy0G7G2GTacN/"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxsX+lEWkHZt9NOvn9yYFP0Z++186LY4b97C4mwj/f2"
      # note: ssh-copy-id will add user@your-machine after the public key
      # but we can remove the "@your-machine" part
    ];

    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      helix
      tree
      hyfetch
      htop
    ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDVNo871p97NTefP52KYiwuch+FaVScxvcFd9fg0yykySTq7Y5JsxrJQgTnox/oDa0O87OyHD/GHQljAXkqiHpDkExbiGjDmGXJSKReKH061F4FqBnDIwYRzUu9Cxjl4MNqsU0RqLaz4+F42c/L7GROQwjEPUb8JHThRiI5FJnDvvB+oBLBxeyQA4v3O4i8DaDQayTr/XB+aSlhNwKrb6cjjL93AHT1uE53yY5jn4kZX+RiPQhH7rvt9N6E4Yr3CG6nUgRCUS0L66d9yfrq0XAbAVk9F+viV7Nk9qy4MWHtXZ4h0qUlzrGALPgGsCGiLGd4NvEgeCcV4nvxdmevxTSdKlJP75xlmlLVXGyhqCZkTsxm/png2UvDl+p0pLyrgNaNoXPdE0Jbv7C28WX36Nast1QFSMUhexzuOx8OgaOioeXVfK98AouqWb58iPBCvgreUIH/gJhZcnlB/Foo1KSO+fJNH8hAsLH7w0mnKyHhJjkrjjwUqsnpepB3SOLfZTE="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMPg5zmlQRhBxKeWRhpt5ajmxlIHvF43TI+9rIi5O6Lw"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/RmFnel8pcZT9nh7EAfKfAekt3BoEXy0G7G2GTacN/"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxsX+lEWkHZt9NOvn9yYFP0Z++186LY4b97C4mwj/f2"
      # note: ssh-copy-id will add user@your-machine after the public key
      # but we can remove the "@your-machine" part
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.jitsi-meet = {
    enable = true;
    hostName = "nonix.sakamoto.pl";
    interfaceConfig = {
      SHOW_JITSI_WATERMARK = false;
    };
    config = {
      prejoinPageEnabled = true;
      disableModeratorIndicator = true;
    };
  };

  security.acme = {
    acceptTerms = true; # ensure that you have read the subscriber agreement (https://letsencrypt.org/repository/)
    defaults.email = "aprl@acab.dev"; # change this to your email address
  };

  services.hydra = {
    enable = true;
    useSubstitutes = true;
    port = 1337;
    smtpHost = "mail.sakamoto.pl";
    notificationSender = "hydra@sakamoto.pl";
    minimumDiskFreeEvaluator = 5;
    minimumDiskFree = 5;
    listenHost = "*";
    buildMachinesFiles = [];
    hydraURL = "https://hydra.nonix.sakamoto.pl";
  };

  services.postgresql.enable = true;
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "hydra.fediverse.gay" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:1337";
          proxyWebsockets = true;
          extraConfig = ''
            sub_filter "http://127.0.0.1:1337/" "https://hydra.fediverse.gay/";
            sub_filter_once off;
          '';
        };
      };
      "attic.fediverse.gay" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  services.atticd = {
    enable = true;
    credentialsFile = "/root/attic-creds";
    settings = {
      listen = "[::]:8080";
      # Data chunking
      #
      # Warning: If you change any of the values here, it will be
      # difficult to reuse existing chunks for newly-uploaded NARs
      # since the cutpoints will be different. As a result, the
      # deduplication ratio will suffer for a while after the change.
      chunking = {
        # The minimum NAR size to trigger chunking
        #
        # If 0, chunking is disabled entirely for newly-uploaded NARs.
        # If 1, all NARs are chunked.
        nar-size-threshold = 64 * 1024; # 64 KiB

        # The preferred minimum size of a chunk, in bytes
        min-size = 16 * 1024; # 16 KiB

        # The preferred average size of a chunk, in bytes
        avg-size = 64 * 1024; # 64 KiB

        # The preferred maximum size of a chunk, in bytes
        max-size = 256 * 1024; # 256 KiB
      };
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}


