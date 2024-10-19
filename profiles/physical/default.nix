{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
  ];
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;

  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = false;
}
