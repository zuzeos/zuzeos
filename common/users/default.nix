{ lib, ... }: {
  imports = builtins.map (x: ./${x}) (
    builtins.attrNames (
      lib.filterAttrs (name: type: type == "directory") (
        builtins.readDir ./.)));
}
