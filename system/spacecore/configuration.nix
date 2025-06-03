{ lib, pkgs, ... }: let
  latestZfsCompatibleLinuxPackages = lib.pipe pkgs.linuxKernel.packages [
    builtins.attrValues 
    (builtins.filter (kPkgs:
      (builtins.tryEval kPkgs).success
      && kPkgs ? kernel
      && kPkgs.kernel.pname == "linux"
      && !kPkgs.zfs_unstable.meta.broken
    ))
    (builtins.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)))
    lib.last
  ];
in
{
  imports = [
    ../../common
    ../../profiles/physical
    ../../profiles/headless
    ../../services/powerdns
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  zuze.deployment = {
    targetHost = "192.168.69.126";
    tags = [
      "web"
      "infra-local"
    ];
  };
  networking.hostName = "spacecore";
  networking.domain = "";

  boot.kernelPackages = latestZfsCompatibleLinuxPackages;
  services.zfs.autoScrub.enable = true;

  programs.zsh.enable = true;
  users.users.aprl = {
    extraGroups = [ "wheel" "pipewire" "media" "libvirtd" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
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

  users.users.lucy = { # lucy
    isNormalUser = true;
    extraGroups = [ "pipewire" "media" "libvirtd" ];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH33CTPbjUqOXXUNd3/M0Zv8nFQyCD0hGFbagjt5/8JI lunary@celesteflare"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.checkJournalingFS = false;
  services.zfs.autoSnapshot.enable = true;

  virtualisation.libvirtd.enable = true;

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

  services.paperless = {
    enable = true;
    consumptionDirIsPublic = true;
    address = "0.0.0.0";
    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };

  networking.interfaces."eno1".useDHCP = false;
  networking.bridges."br0".interfaces = [ "eno1" ];
  networking.interfaces."br0".useDHCP = true;

  system.stateVersion = lib.mkForce "24.11";
}
