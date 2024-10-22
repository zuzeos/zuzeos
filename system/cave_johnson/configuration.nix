{ config, inputs, lib, pkgs, ... }: {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
    ../../common
    ../../profiles/distributed
    ../../profiles/graphical
    ../../profiles/physical
    ../../profiles/systemd-boot
    ../../services/garlic
    #../../services/home-assistant
    ./hardware-configuration.nix
  ];

  # Bootloader.
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

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "Europe/Berlin";
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [ 
        "--network=host" 
        "--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
      ];
    };
  };


  networking.hostName = "cave"; # Define your hostname.
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
  services.xserver.xkb = {
    layout = "gb";
    variant = "intl";
  };

  # Configure console keymap
  console.keyMap = "uk";

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
      webcord
      signal-desktop
      tree
      thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "olm-3.2.16"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget

    waydroid
    qemu

    #iinputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    #inputs.nix-gaming.packages.${pkgs.system}.rocket-league

    #test.sharkey

    lutris
    bottles

    prismlauncher

    nheko
    rustup

    colmena

    inkscape

    mesa-demos

    skypeforlinux

    yubikey-personalization

    config.nur.repos.aprilthepink.stellwerksim-launcher
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  hardware.steam-hardware.enable = true;

  services.flatpak.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];
    enable32Bit = true;
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = lib.mkForce "23.11"; # Did you read the comment?

}
