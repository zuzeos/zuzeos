{ lib, ... }: {
  options = {
    system.nixos.codeName = lib.mkOption { readOnly = false; };
  };
  config = {
    system.nixos.codeName = "Neverland";
  };
}
