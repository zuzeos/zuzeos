# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

  { config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../baseconf.nix
      ../../gnome.nix
      #../../modules/home-assistant.nix
      ../../modules/distributed.nix
      ../../modules/garlic.nix
      ../../modules/onion.nix
      ../../modules/spotify.nix
      ../../modules/gaming.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.ssh.startAgent = false;

  services.pcscd.enable = true;

  virtualisation.waydroid.enable = true;

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  systemd.services.nessus = {
    enable = true;
    path = [ config.nur.repos.aprilthepink.tennable-client-own pkgs.coreutils ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = ''${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/echo "/opt/nessus_agent/sbin/nessus-service -q" | ${config.nur.repos.aprilthepink.tennable-client-own}/bin/nessus-agent-shell' '';
      #Type = "notify";
      Type = "simple";
      #User = "root";
    };
  };

  zramSwap = {
    enable = true;
  };

  networking.hostName = "ajx2407"; # Define your hostname.
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "gb";
  #  variant = "intl-altgr";
  #};

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aprl = {
    isNormalUser = true;
    description = "Aprl System (April John)";
    extraGroups = [ "wheel" "pipewire" "media" "networkmanager" ];
    packages = with pkgs; [
      firefox
      librewolf
      ungoogled-chromium
      signal-desktop
      tree
      thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget

    waydroid
    qemu

    config.nur.repos.aprilthepink.tennable-client-own

    lutris
    bottles

    nheko
    rustup

    colmena

    inkscape

    mesa-demos

    skypeforlinux
    zoom-us

    yubikey-personalization

    #denic
    clamav
    clamtk
    steam-run
  ];
  services.flatpak.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];
  hardware.opengl.driSupport32Bit = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # AV
  services.clamav = {
    scanner.enable = true;
    updater.enable = true;
    fangfrisch.enable = true;
    fangfrisch.settings = {
      sanesecurity.enabled = false;
    };
    daemon.settings = {
      OnAccessMountPath = "/home/aprl/Downloads";
      OnAccessPrevention = false;
      OnAccessExtraScanning = true;
      OnAccessExcludeUname =  "clamav";
      VirusEvent = "/etc/clamav/virus-event.bash";
      User = "clamav";
    };
    daemon.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
