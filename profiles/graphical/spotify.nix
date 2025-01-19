{ pkgs, lib, inputs, ... }:
{
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        bitrate = 320;
        use_mpris = true;
        device_name = "TowerDemon";
        device_type = "speaker";
        backend = "pulseaudio";
      };
    };
  };
  environment.systemPackages = with pkgs; [ 
    gnomeExtensions.appindicator
    gnomeExtensions.gravatar
    spotify
  ];
}
