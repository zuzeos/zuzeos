{ pkgs, lib, inputs, ... }:
{
  environment.systemPackages = [
    pkgs.tor-browser
  ]; 
}
