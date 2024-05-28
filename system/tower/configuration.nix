# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  networking.hostName = "tower"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  #i18n.defaultLocale = "de_DE.UTF-8";
  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "de";
  #  useXkbConfig = true; # use xkb.options in tty.
  #};

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  security.pki.certificates = [ 
    ''
      -----BEGIN CERTIFICATE-----
MIIEcTCCAtmgAwIBAgIQK7Qt0M9V1XKTXYVznYpq7TANBgkqhkiG9w0BAQsFADBR
MR4wHAYDVQQKExVta2NlcnQgZGV2ZWxvcG1lbnQgQ0ExEzARBgNVBAsMCmFwcmxA
dG93ZXIxGjAYBgNVBAMMEW1rY2VydCBhcHJsQHRvd2VyMB4XDTI0MDUxNDAwMTYx
MVoXDTM0MDUxNDAwMTYxMVowUTEeMBwGA1UEChMVbWtjZXJ0IGRldmVsb3BtZW50
IENBMRMwEQYDVQQLDAphcHJsQHRvd2VyMRowGAYDVQQDDBFta2NlcnQgYXBybEB0
b3dlcjCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGBAMDRZqIZZU/jBkWK
OYE7tlaXrGte0eWzKaD25/MKHfRCApCQyBd2QLltijDhMejAQNFZwj21K0f9t4/X
RxTz4MM0x4B18pJHfNJx6A2iC4Z30KbeiLmI8PuX7TReYiO53LvNhemL3wx/FlMi
YtCYuGrBMsn0rWqrVkJujqBo6ZKeThRB2gZLiG/DzlW1HiY2lQjvRTbe9niHH8bS
5z6VetWJvJ0Us9iwhC5C/crkSu/13LgI61YVn9dp8IhMaz190BiTBktjp+ez5xjc
TAEQYxL2g4kV34RvzCDAiK5MUFR0y9tMtIiTsSLUuwCJYl4GbZx2qHAH0n1mXZ4p
jDNARG4aJZID9kyqZuIoin2RgfhoFadHShxnA1+O/DE9B4aOAfXPilxEoZtdBm73
aey4PUSE2NXmm9GnyqLv12QwKPH189ePBvjqioLYvioq8mvmc72N6CHv+g29Nfa2
wIiEtmtFvI5S0KNVxpF30ZGIBAYuJj+QmN7sn0H+HDqnO2R63wIDAQABo0UwQzAO
BgNVHQ8BAf8EBAMCAgQwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUX8ch
wHDVB55IFaks/k6e4Jm9y0YwDQYJKoZIhvcNAQELBQADggGBAB1HkCLyXLgG4M9Y
Udtu4dYbtrOvGYHzIBkVcGOd+9HNbD9f0ElopKEveZLYlZDio3M9ostKctE70INS
sJcRrrNE8F/L8NF4bW9F7cBHveUvfzM/zp9iAty8iZjAhUZXSg9Lenjg55RQvjuR
bKfy64+uVCv/aCK3Znz0OAH33bHlvjdRiMbojDsEvVBtrnZCUSUKgBZxlM2D7axM
ysdWiPxGprh8sAZzddak0fp+O8Nuw6BgtFd9AaMEt/g2TwSYPGJesvr5Ie54/rh7
fiiFdu2Puf2nA+1fIf1SHZOSDmGFTUo6s0s3VyjErJee225bT6S2xzMVr5OXtcpd
IHYu66SqoZfFOLpgRphjxeq/V4At4uR3wdbJq0fVECiDICLa93xaeDGnEPKl2cmj
znWwMFa05ADrPRH/ABnb7fwnVoKkR16KQQoMTfOcnuv7l6ouKy9/ydaMo1TGyS0i
den0I53pA1L5bIb//uZ1LmACeiM+d/k4kJIvWJusONprzGWAPA==
-----END CERTIFICATE-----
    '' 
  ];
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.100.1.3/32" ];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/aprl/wireguard-keys/private";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "m9E3c0z0BYgcGrveu1E2V8p+XrrR4yDSpfo00bjZ5DA=";

          # Forward all the traffic via VPN.
          #allowedIPs = [ "0.0.0.0/0" ];
          # Or forward only particular subnets
          allowedIPs = [ "10.100.0.0/16" "192.168.10.0/24" "192.168.2.0/24" ];

          # Set this to the server IP and port.
          endpoint = "162.55.242.111:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
  virtualisation.waydroid.enable = true;

  # Configure keymap in X11
  #services.xserver.xkb.layout = "de";
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
    extraGroups = [ "wheel" "pipewire" "media" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      librewolf
      ungoogled-chromium
      webcord
      signal-desktop
      tree
    ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget

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

    config.nur.repos.aprilthepink.stellwerksim-launcher
    config.nur.repos.aprilthepink.suyu-mainline
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

  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];
  hardware.opengl.driSupport32Bit = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
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
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

