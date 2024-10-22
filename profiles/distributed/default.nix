{ lib, ... }: {
  nix.buildMachines = [
    {
      hostName = "integra.kyouma.net";
      sshUser = "nix-ssh";
      maxJobs = 2;
      speedFactor = 4;
      systems = [ "aarch64-linux" ];
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      sshKey = "/home/aprl/.ssh/id_ed25519";
    }
  ] ++ lib.forEach (lib.genList (i: i + 1) 8) (num: {
      hostName = "build-worker-0${toString num}";
      sshUser = "root";
      maxJobs = 2;
      speedFactor = 20;
      systems = [ "i686-linux" "x86_64-linux" ];
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "gccarch-x86-64" "gccarch-x86-64-v2" "gccarch-x86-64-v3" ];
      sshKey = "/home/aprl/.ssh/id_ed25519";
  });
  nix.distributedBuilds = true;
  programs.ssh = {
    knownHosts = {
      "integra.kyouma.net".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBwEQiSfaDrUAwgul4mktusBPcIVxI4pLNDh9DPopVU";
      "[build-worker-kyoumanet.fly.dev]:2201".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL2M97UBHg9aUfjDUxzmzg1r0ga0m3/stummBVwuEAB";
      "[build-worker-kyoumanet.fly.dev]:2202".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTwVKL0P0chPM2Gz23rbT94844+w1CGJdCaZdzfjThz";
      "[build-worker-kyoumanet.fly.dev]:2203".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAjy2eZGJQeAYy0+fLgW9jiS0jVY2LInY0NDMnzCvvKp";
      "[build-worker-kyoumanet.fly.dev]:2204".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN72OyD9LYy4hq0WZ7ie5RPV+G54UreEJiA/RubjGoe9";
      "[build-worker-kyoumanet.fly.dev]:2205".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNh1o1I98XrI2XmOI6Q0aHPfyLCIQwKkKOxGUUeXL9v";
      "[build-worker-kyoumanet.fly.dev]:2206".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGf0kxGgwOG9KhUhvxxTSiQC5YikrzZXKDgSpBw33qN4";
      "[build-worker-kyoumanet.fly.dev]:2207".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9z95a6Fn/dB+iNigEYpuJdBnBwCkIZYaKHcFbGP+RY";
      "[build-worker-kyoumanet.fly.dev]:2208".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAk+FNMhTfAVqk3MfLp4QiG/i5ti53DlpnC0q+sOvU9O";
    }; 
    extraConfig = lib.concatLines (lib.genList (i: ''
      Host build-worker-0${toString (i + 1)}
        Hostname build-worker-kyoumanet.fly.dev
        Port 220${toString (i + 1)}
    '') 8);
  };
}

