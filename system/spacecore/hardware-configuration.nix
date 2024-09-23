{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "r8169" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "r8169" ];
  boot.kernelModules = [ "kvm-intel" "r8169" ];
  boot.extraModulePackages = [ ];

  boot.zfs.devNodes = "/dev/disk/by-id";

  #fileSystems."/" =
  #  { device = "zroot/root/nixos";
  #    fsType = "zfs";
  #  };

  #fileSystems."/boot" =
  #  { device = "/dev/disk/by-uuid/383E-5B1C";
  #    fsType = "vfat";
  #    options = [ "fmask=0022" "dmask=0022" ];
  #  };

  boot.loader.grub = {
    # usually no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ "/dev/disk/by-uuid/383E-5B1C" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostId = "2a7da1aa";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    extraConfig = ''
      PrintLastLog no
    '';
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}