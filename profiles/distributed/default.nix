{ pkgs, lib, inputs, ... }:
{
  nix = {
    buildMachines = [
      #{
      #  hostName = "hyperion.kookie.space";
      #  protocol = "ssh-ng";
      #  maxJobs = 8;
      #  sshKey = "~/.ssh/aprl_nopass";
      #  sshUser = "aprl";
      #  system = "x86_64-linux";
      #}
    ];
  };
}
