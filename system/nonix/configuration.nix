{ config, lib, pkgs, ... }: {
  imports = [
    ../../common
    ../../profiles/headless
    ../../services/nginx
    ./hardware-configuration.nix
  ];

  zuze.deployment = {
    targetHost = "sakamoto.pl";
    targetPort = 13370;
    tags = [
      "infra-attic"
    ];
  };
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  environment.systemPackages = with pkgs; [
    signal-cli
    screen
  ];

  networking.hostName = "sakanixno";
  networking.firewall.enable = false;

  nix.buildMachines = [
    { hostName = "localhost";
      system = "x86_64-linux";
      supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
      maxJobs = 8;
    }
  ];
  services.vaultwarden = {
    enable = true;
    environmentFile = "/var/lib/vaultwarden.env";
    config = {
      DOMAIN = "https://vault.internal.versia.pub";
      SIGNUPS_ALLOWED = true;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
      SMTP_HOST = "mail.sakamoto.pl";
      SMTP_PORT = 465;
      SMTP_SECURITY = "force_tls";
      SMTP_FROM = "noreply-bakka@sakamoto.pl";
      SMTP_USERNAME = "noreply-bakka@sakamoto.pl";
      SMTP_FROM_NAME = "Vault Server";
    };
  };

  services.pretix = {
    enable = true;
    settings = {
      pretix.url = "https://stuff.bak.pink";
      pretix.registration = false;
      pretix.instance_name = "BAK Queer Postoffice";
      mail = {
        from = "noreply-bakka@sakamoto.pl";
        password = "3SMdf3xeJ6JqUqjRxP2LhGQepdE63j";
        user = "noreply-bakka@sakamoto.pl";
        host = "mail.sakamoto.pl";
        ssl = true;
        port = 465;
      };
    };
    nginx.enable = true;
    nginx.domain = "stuff.bak.pink";
    plugins = with config.services.pretix.package.plugins; [
      passbook
      pages
      stretchgoals
    ];
  };


  services.pgadmin = {
    enable = true;
    initialPasswordFile = "/var/leckesiemi";
    initialEmail = "aprl@acab.dev";
    openFirewall = true;
  };

  services.minecraft-server = {
    dataDir = "/var/lib/minecraft";
    enable = true;
    eula = true;
    jvmOpts = "-Xms4092M -Xmx4092M";
    package = pkgs.papermcServers.papermc-1_20_1;
  };

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

  services.hydra = {
    enable = true;
    useSubstitutes = true;
    port = 1337;
    smtpHost = "mail.sakamoto.pl";
    notificationSender = "hydra@sakamoto.pl";
    minimumDiskFreeEvaluator = 5;
    minimumDiskFree = 5;
    listenHost = "*";
    hydraURL = "https://hydra.nonix.sakamoto.pl";
  };

  services.postgresql.enable = true;
  services.nginx.virtualHosts = {
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

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = lib.mkForce "23.11"; # Did you read the comment?
}


