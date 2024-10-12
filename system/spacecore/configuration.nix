{ lib, pkgs, config, ... }: 
let
  latestZfsCompatibleLinuxPackages = lib.pipe pkgs.linuxKernel.packages [
    builtins.attrValues
    (builtins.filter (
      kPkgs:
      (builtins.tryEval kPkgs).success
      && kPkgs ? kernel
      && kPkgs.kernel.pname == "linux"
      && !kPkgs.zfs.meta.broken
    ))
    (builtins.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)))
    lib.last
  ];
in
{
  imports = [
    ./hardware-configuration.nix
    ../../baseconf.nix
    ./disk-config.nix
    ../../modules/gaming/satisfactory.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "spacecore";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPKL1+FX6pt3EasE9ZIb9Qg+LvFVagAVi2Uy9X2E90n aprl@acab.dev"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxsX+lEWkHZt9NOvn9yYFP0Z++186LY4b97C4mwj/f2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpyVefbZLkNVNzdSIlO6x6JohHE1snoHiUB3Qdvl5I2"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0v3tUBNEUxfoOQBFb+N2DUBQDay0iFggUWa9Nd+BtFLOKkz+RRto3eBF0ZiJZVUxv/hLb8m2s45hcMw8agwuPrXMe5085T1fzkvPdKAPZdsT/cCmBi1OsoLjAKBFIdM4lcV0A2cca8hip+/ZPpjFPUWx73/672gAPHU7co7fP8+8CSf9dx+WIeLx3yaYHYZ/th3dB5auX3VjOazS8MojsAorwTUeBoPamHQ5dFeNafhFUL/hhtGkUI1cNHUn3bJd2V7AKTW3UglK7hVgMJPrzVS31OlpcJEf6S5XgKTWdOSwubn1bs5Lt6YYRDU24NV6CGrwKgCJSRxzNMLwpnFKiSXpO8FzkqWHYWyju141hQcFF31aZIV+7YcwEt5ZukLjFOpVtpbSXvJYigOUzGi34P3/OAGshDXjTQjvM8GIir49gx3b2Nwhg0z4UHBkAKZvDDFPHDMJoclvnhITojaAojfC9zmMCO5ZaEsk8yv7c/lWQumzRpfldWF4mwHvhD5kTADbhRdO7WTdX7AaiAYINooToeWKjFe2wn3rFubPUppptqtP03mmvs7vhhgnEVBbGZRJK3GTVk1XcsfF9rDKzewSa+wb4LsBoZtFRhc8cJqHGlKWSNk7dQ04B1atPyNLKGpGoo/UIPxyZ6bSqFVxY3nhz46VZ6z8XWI48z0/fRQ=="
  ];

  boot.kernelPackages = latestZfsCompatibleLinuxPackages;
  services.zfs.autoScrub.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "aprl@acab.dev";
  };

  users.users.aprl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "pipewire" "media" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPKL1+FX6pt3EasE9ZIb9Qg+LvFVagAVi2Uy9X2E90n aprl@acab.dev"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxsX+lEWkHZt9NOvn9yYFP0Z++186LY4b97C4mwj/f2"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpyVefbZLkNVNzdSIlO6x6JohHE1snoHiUB3Qdvl5I2"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0v3tUBNEUxfoOQBFb+N2DUBQDay0iFggUWa9Nd+BtFLOKkz+RRto3eBF0ZiJZVUxv/hLb8m2s45hcMw8agwuPrXMe5085T1fzkvPdKAPZdsT/cCmBi1OsoLjAKBFIdM4lcV0A2cca8hip+/ZPpjFPUWx73/672gAPHU7co7fP8+8CSf9dx+WIeLx3yaYHYZ/th3dB5auX3VjOazS8MojsAorwTUeBoPamHQ5dFeNafhFUL/hhtGkUI1cNHUn3bJd2V7AKTW3UglK7hVgMJPrzVS31OlpcJEf6S5XgKTWdOSwubn1bs5Lt6YYRDU24NV6CGrwKgCJSRxzNMLwpnFKiSXpO8FzkqWHYWyju141hQcFF31aZIV+7YcwEt5ZukLjFOpVtpbSXvJYigOUzGi34P3/OAGshDXjTQjvM8GIir49gx3b2Nwhg0z4UHBkAKZvDDFPHDMJoclvnhITojaAojfC9zmMCO5ZaEsk8yv7c/lWQumzRpfldWF4mwHvhD5kTADbhRdO7WTdX7AaiAYINooToeWKjFe2wn3rFubPUppptqtP03mmvs7vhhgnEVBbGZRJK3GTVk1XcsfF9rDKzewSa+wb4LsBoZtFRhc8cJqHGlKWSNk7dQ04B1atPyNLKGpGoo/UIPxyZ6bSqFVxY3nhz46VZ6z8XWI48z0/fRQ=="
    ];
  };

  users.users.sdomi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "pipewire" "media" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFHcfS3YKXUX4N8cD2IEF3GxHvb+IlynSSudDF1/e3U domi@kita"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImhJ+2pw5c1Tzx/g+S04on5bUXhwzloqRaiXti5UC7A domi@zork"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFiEVfK9gidYkQpfVZzykKj/eltdPqeFtcNhMgH6N7Oi domi@nijika"

      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPkJRQYGIVC//ofxYrIxF3nP3D8gTDSSSMyEzG6JVQii domi@sakamoto"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDVJ307BmZvIkQMxFIGe3nTYOL/Qo0AeaEPmxUFG+vSASPdTaSM4PHYh6WgJIRNsKcZHCF9gCFniY0TCrC3chBJRsRxTonCZteiib3/rpn0c+jFMtfi+SId56/BhQP8S3LAw7EpciQ7U5qmwYc5f5hhhXnEFhT2SoxxA45eIBwZjTo0aE1SC1M5buzVW+VnPuV2+PYE8wQjSYUnUChrJOgZeCapbIvfz8Ml7ppX1LmFLCeLHyZHJpzhoz+6Ios7FbkuhuaCTjMU+MqmSzM4MBDRThI13e/lWsExGDh1BlSTB4FawUCvd90Z0KBp671UsA0SXzzB4UQujVSNO/yDwLYvldlV3mXkLAsB0pdmRfGFAD0C4gxe8yG5jM6FxBYV4ZLEAvKRLROr4SaWJ4OXh7cplnr78zQit0r3erqusf28xYnOvF0zTvCMvPPFBVBGqolYPPFUleClZ1HaoTnM36NDAdyO5P9/4og5y/FfRDajql3HhBNA8MV+8FN/leJ2Hfk= domi@hakase"

      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDdkPtfJBlasAiNI8Ir5qVpjkQKxb7LIy2X3N8RRFNQq JuiceSSH"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  services.powerdns = {
    enable = true;
    extraConfig = ''
      loglevel = 4
      resolver = 9.9.9.9
      rng=urandom
      expand-alias = yes
      outgoing-axfr-expand-alias = yes

      autosecondary = yes
      workaround-11804=yes

      default-ksk-algorithm = ed25519
      default-zsk-algorithm = ed25519

      # ns1.homecloud.lol
      allow-axfr-ips    = 217.69.6.150,2a05:f480:1c00:7f:5400:5ff:fe05:75e3
      allow-notify-from = 217.69.6.150,2a05:f480:1c00:7f:5400:5ff:fe05:75e3
      also-notify       = 217.69.6.150,2a05:f480:1c00:7f:5400:5ff:fe05:75e3

      # miyuki.sakamoto.pl
      allow-axfr-ips    += 5.78.65.112,2a01:4ff:1f0:f98::
      allow-notify-from += 5.78.65.112,2a01:4ff:1f0:f98::
      also-notify       += 5.78.65.112,2a01:4ff:1f0:f98::

      # ns1.famfo.xyz
      allow-axfr-ips    += 116.202.10.127,2a01:4f8:c012:fb3::1
      allow-notify-from += 116.202.10.127,2a01:4f8:c012:fb3::1
      also-notify       += 116.202.10.127,2a01:4f8:c012:fb3::1

      # ns2.famfo.xyz
      allow-axfr-ips    += 150.107.200.153,2406:ef80:4:2afe::1
      allow-notify-from += 150.107.200.153,2406:ef80:4:2afe::1
      also-notify       += 150.107.200.153,2406:ef80:4:2afe::1

      # sakamoto.pl
      allow-axfr-ips    += 185.236.240.103,2a0d:eb00:8006::acab
      allow-notify-from += 185.236.240.103,2a0d:eb00:8006::acab
      also-notify       += 185.236.240.103,2a0d:eb00:8006::acab

      # ns1.fops.at
      allow-axfr-ips    += 176.126.242.104,2a00:1098:37a::2
      allow-notify-from += 176.126.242.104,2a00:1098:37a::2
      also-notify       += 176.126.242.104,2a00:1098:37a::2

      # ns7.kytta.dev
      allow-axfr-ips    += 185.154.195.110,2a03:6f00:4::78ec
      allow-notify-from += 185.154.195.110,2a03:6f00:4::78ec
      also-notify       += 185.154.195.110,2a03:6f00:4::78ec

      #setgid = pdns
      #setuid = pdns

      webserver = yes
      webserver-port = 8053
      webserver-allow-from = 192.168.0.0/16
      webserver-address = 192.168.69.126
      api = yes

      launch = gsqlite3
      gsqlite3-database = /var/lib/pdns/pdns.sqlite3
      gsqlite3-dnssec = yes

      default-soa-content = nsfrah.aprilthe.pink. dns-is-borkd.sdomi.pl 300 10800 3600 604800 3600

      # Refrence: https://doc.powerdns.com/authoritative/settings.html
      # Dump all opitons (including default values): pdns_control current-config

      local-address = ::1, 192.168.69.126
      version-string = sf-aprlI
      loglevel-show = yes
      #loglevel = 7
      primary = yes
      secondary = yes
      default-soa-edit = INCEPTION-INCREMENT
    '' ;
    secretFile = "/run/keys/powerdns.env";
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.checkJournalingFS = false;
  services.zfs.autoSnapshot.enable = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
   ];

   services.jellyfin = {
     enable = true;
     openFirewall = true;
   };

  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      MusicFolder = "/mnt/music";
      Address = "0.0.0.0";
    };
  };

  services.satisfactory = {
    enable = true;
    beta = "public";
    maxPlayers = 8;
  };

   system.stateVersion = "24.11";

}