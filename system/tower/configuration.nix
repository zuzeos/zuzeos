{ config, pkgs, inputs, ... }: let
  nur-no-pkgs = import inputs.nur {
     nurpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
  };
in {
  imports = [
    nur-no-pkgs.repos.spitzeqc.modules.yacy
    ../../common
    ../../profiles/distributed
    ../../profiles/graphical
    ../../profiles/physical
    ../../profiles/systemd-boot
    ../../services/garlic
    # ../../services/home-assistant
    ./hardware-configuration.nix
  ];

  services.yacy = {
    enable = true;
    package = pkgs.nur.repos.spitzeqc.yacy;
  };

  nixpkgs.overlays = [ inputs.nur.overlay ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  networking.hostName = "tower"; # Define your hostname.

  networking.nat = {
    enable = true;
    externalInterface = "enp34s0";
    internalInterfaces = [ "wg0" "wg1" ];
  };
  networking.firewall.allowedUDPPorts = [ 51820 51821 ];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.1.3/32" ];
      listenPort = 51820;
      privateKeyFile = "/home/aprl/wireguard-keys/private";
      peers = [
        {
          publicKey = "m9E3c0z0BYgcGrveu1E2V8p+XrrR4yDSpfo00bjZ5DA=";
          #allowedIPs = [ "0.0.0.0/0" ];
          allowedIPs = [ "10.100.0.0/16" "192.168.10.0/24" "192.168.2.0/24" ];

          # ToDo: route to endpoint not automatically configured 
          # https://wiki.archlinux.org/index.php/WireGuard#Loop_routing 
          # https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
          endpoint = "162.55.242.111:51820"; 
          persistentKeepalive = 25;
        }
      ];
    };
    wg1_fwd = {
      ips = [
        "192.168.251.251"
        "2a0d:eb00:8006:2137::acab"
      ];
      privateKeyFile = "/home/aprl/wireguard-keys/domi-wg-priv";
      listenPort = 51821;
      allowedIPsAsRoutes = false;
      postSetup = ''
        echo 2 > /proc/sys/net/ipv4/conf/wg1_fwd/rp_filter
        ip r a 192.168.250.0/23 dev wg1_fwd
        ip r a 192.168.254.0/24 dev wg1_fwd
        ip r a 172.16.0.0/16 dev wg1_fwd
        ip r a 192.168.248.0/24 dev wg1_fwd
      '';
      peers = [
        {
          publicKey = "skmt/OMUt5JYt0OPQgLo1bgOltffUGEZf1SdM5/50hk=";
          allowedIPs = [
            "192.168.250.0/23"
            "192.168.254.0/24"
            "192.168.248.0/24"
            "172.16.0.0/23"
            "2a0d:eb00:8006::/48"
            "0.0.0.0/0"
          ];
          endpoint = "4.sakamoto.pl:44444";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  security.pki.certificates = [ ''
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
  '' ];

  environment.systemPackages = with pkgs; [
    #inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    #inputs.nix-gaming.packages.${pkgs.system}.rocket-league
    #test.sharkey

    config.nur.repos.aprilthepink.stellwerksim-launcher
    #config.nur.repos.aprilthepink.suyu-mainline
    kubectl
    kubernetes-helm
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

  services.xserver.videoDrivers = [
    "amdgpu-pro"
    "modesetting"
    "fbdev"
  ];

  system.stateVersion = "24.05";
}
