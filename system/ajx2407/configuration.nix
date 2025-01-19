# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

  { config, pkgs, lib, ... }:

{
  imports = [
    ../../common
    ../../profiles/distributed
    ../../profiles/graphical
    ../../profiles/physical
    ../../profiles/systemd-boot
    ../../services/garlic
    #../../services/home-assistant.nix
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  users.users.aprl.extraGroups = [ "dialout" ];

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  #38c3
  networking.networkmanager.ensureProfiles.profiles = {
  "38C3" = {
    connection = {
      id = "38C3";
      type = "wifi";
    };
    wifi = {
      mode = "infrastructure";
      ssid = "38C3";
    };
    wifi-security = {
      auth-alg = "open";
      key-mgmt = "wpa-eap";
    };
    "802-1x" = {
      anonymous-identity = "38C3";
      eap = "ttls;";
      identity = "38C3";
      password = "38C3";
      phase2-auth = "pap";
      altsubject-matches = "DNS:radius.c3noc.net";
      ca-cert = "${builtins.fetchurl {
        url = "https://letsencrypt.org/certs/isrgrootx1.pem";
        sha256 = "sha256:1la36n2f31j9s03v847ig6ny9lr875q3g7smnq33dcsmf2i5gd92";
      }}";
    };
    ipv4 = {
      method = "auto";
    };
    ipv6 = {
      addr-gen-mode = "default";
      method = "auto";
    };
  };
};

  networking.hostName = "ajx2407"; # Define your hostname.

  networking.domain = "";
  networking.hosts = {
    "185.97.174.196" = ["smtp.mailbox.org"];
    "185.97.174.199" = ["imap.mailbox.org"];
    "80.241.60.197" = ["office.mailbox.org"];
    "185.97.174.194" = ["mailbox.org"];
    "80.241.60.221" = ["login.mailbox.org"];
    "80.241.60.198" = ["dav.mailbox.org"];
    "80.241.60.226" = ["manage.mailbox.org"];
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.ssh.startAgent = false;

  services.pcscd.enable = true;

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

  programs.nix-ld.enable = true;

  systemd.services.nessus = {
    enable = true;
    path = [ pkgs.nur.repos.aprilthepink.tennable-client-own pkgs.coreutils ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = ''${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/echo "/opt/nessus_agent/sbin/nessus-service -q" | ${pkgs.nur.repos.aprilthepink.tennable-client-own}/bin/nessus-agent-shell' '';
      #Type = "notify";
      Type = "simple";
      #User = "root";
      CPUWeight = 10;
      CPUQuota = "20%";
      IOWeight = 10;
    };
  };


  # Configure console keymap
  console.keyMap = "de";

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  environment.systemPackages = with pkgs; [
    nur.repos.aprilthepink.tennable-client-own

    #denic
    clamav
    clamtk
    steam-run

    poetry

    kubectl
    krew
    kubelogin-oidc
    kubernetes-helm

    jetbrains.rust-rover
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
      xdg-desktop-portal
    ];
  };

  system.stateVersion = lib.mkForce "23.11"; # Did you read the comment?
}
