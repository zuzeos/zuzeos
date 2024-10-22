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

  networking.hostName = "cave"; # Define your hostname.

  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.ssh.startAgent = false;

  services.pcscd.enable = true;


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

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "intl";
  };

  # Configure console keymap
  console.keyMap = "uk";

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  environment.systemPackages = [
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

  system.stateVersion = lib.mkForce "23.11"; # Did you read the comment?
}
