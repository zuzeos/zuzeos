{ runCommand }:

runCommand "nix-update-plymouth-theme" { } ''
  mkdir -p $out/share/plymouth/themes
  cp -r ${./nix-update} $out/share/plymouth/themes/nix-update

  # Fix paths: the upstream .plymouth file uses /usr/share, but on NixOS
  # everything lives under a Nix store path.
  substituteInPlace $out/share/plymouth/themes/nix-update/nix-update.plymouth \
    --replace-fail "/usr/share" "$out/share"
''
