{ pkgs, lib, inputs, ... }:
{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "analytics"
      "default_config"
      "esphome"
      "my"
      "shopping_list"
      "wled"
      "met"
      "telegram_bot"

    ];
    config = null;
  };


  nixpkgs.config.permittedInsecurePackages = [
                "openssl-1.1.1w"
  ];
}
