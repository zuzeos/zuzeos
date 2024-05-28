{ config, ... }:
{
  imports = [ config.nur.repos.spitzeqc.modules.yacy ];
  services.yacy.enable = true;
}
