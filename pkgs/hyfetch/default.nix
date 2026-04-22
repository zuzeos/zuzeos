{ hyfetch, lib }:

hyfetch.overrideAttrs (old: {
  # hyfetch bundles a fork of neofetch as "neofetch" in the source tree,
  # installed as $out/bin/neowofetch.  We patch it with a Python script to:
  #   1. Add a Jester Linux detection block (keyed on /etc/JESTERLINUX) before the NixOS block.
  #   2. Add "jesterlinux" ASCII art (two theatre masks) in get_distro_ascii.
  #
  # The sentinel file is created in common/default.nix:
  #   environment.etc."JESTERLINUX".text = "";
  postPatch = (old.postPatch or "") + ''
    python3 ${./patch-neofetch.py} neofetch
  '';
})
