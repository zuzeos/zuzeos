{ lib, ... }: let
  mapModules = builtins.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./.));
in {
  imports = builtins.map (dir: ./${dir}) mapModules;
}
