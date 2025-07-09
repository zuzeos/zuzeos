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
    ../../pkgs/wazuh
    ../../modules/wazuh
    #../../services/home-assistant.nix
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  users.users.aprl.extraGroups = [ "dialout" ];

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  services.wazuh-agent = {
    enable = true;
    package = pkgs.wazuh-agent;
    managerIP = "2f34th7lo5it.cloud.wazuh.com";
    managerPort = 1514;
    extraConfig = ''
    <ossec_config>
      <client>
        <enrollment>
          <agent_name>ajx2407</agent_name>    <!-- Bitte hier deinen Hostnamen eingeben -->
          <groups>LinuxClients,Clients</groups>          <!-- Komma separierte Liste -->
          <manager_address>2f34th7lo5it.cloud.wazuh.com</manager_address>
        </enrollment>
      </client>
    </ossec_config>
    '';
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
    scanner.enable = false;
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

  # Configure console keymap
  console.keyMap = "de";

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    nur.repos.aprilthepink.tennable-client-own

    #denic
    clamav
    clamtk
    steam-run
    steam

    poetry

    kubectl
    krew
    kubelogin-oidc
    kubernetes-helm

    jetbrains.rust-rover
    deltachat-desktop

    nur.repos.aprilthepink.stellwerksim-launcher

    calibre
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
      xdg-desktop-portal
    ];
  };

  services.udev.extraRules = ''
    #V2 Legacy
SUBSYSTEM=="usb",ATTR{idVendor}=="0483",ATTR{idProduct}=="5750",MODE="0666"
KERNEL=="hidraw*",ATTRS{idVendor}=="0483",ATTRS{idProduct}=="5750",MODE="0666"

#V2
SUBSYSTEM=="usb",ATTR{idVendor}=="0483",ATTR{idProduct}=="[aA]0[eE]7",MODE="0666"
KERNEL=="hidraw*",ATTRS{idVendor}=="0483",ATTRS{idProduct}=="[aA]0[eE]7",MODE="0666"

#V3
SUBSYSTEM=="usb",ATTR{idVendor}=="0483",ATTR{idProduct}=="[aA]0[eE]8",MODE="0666"
KERNEL=="hidraw*",ATTRS{idVendor}=="0483",ATTRS{idProduct}=="[aA]0[eE]8",MODE="0666"

#V4  16D0 0B1A
SUBSYSTEM=="usb",ATTR{idVendor}=="16[dD]0",ATTR{idProduct}=="0[bB]1[aA]",MODE="0666"
KERNEL=="hidraw*",ATTRS{idVendor}=="16[dD]0",ATTRS{idProduct}=="0[bB]1[aA]",MODE="0666"

#5 early iterations 16D0 0B1C
SUBSYSTEM=="usb",ATTR{idVendor}=="16[dD]0",ATTR{idProduct}=="0[bB]1[cC]",MODE="0666"
KERNEL=="hidraw*",ATTRS{idVendor}=="16[dD]0",ATTRS{idProduct}=="0[bB]1[cC]",MODE="0666"

#5 384D 0B1C
SUBSYSTEM=="usb",ATTR{idVendor}=="384[dD]",ATTR{idProduct}=="0[bB]1[cC]",MODE="0666"
KERNEL=="hidraw*",ATTRS{idVendor}=="384[dD]",ATTRS{idProduct}=="0[bB]1[cC]",MODE="0666"
  '';

  system.stateVersion = lib.mkForce "23.11"; # Did you read the comment?
}
