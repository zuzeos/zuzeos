{ ... }: {
  networking = {
    networkmanager = { # easiest to use; most distros use this
      enable = true;
    };

    # Routers are supposed to handle firewall on local networks
    firewall.enable = false;
  };
}
