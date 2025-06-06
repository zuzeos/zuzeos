{ pkgs, ... }: {
  services.monero = {
    enable = true;

    rpc.port = 18089;
    rpc.address = "0.0.0.0";
    rpc.restricted = true;

    limits = {
      upload = 1048576;
      download = 1048576;
    };

    extraConfig = ''
      log-level=0
      public-node=1 # Advertises the RPC-restricted port over p2p peer lists
      p2p-bind-ip=0.0.0.0 # Bind to all interfaces (the default)
      p2p-bind-port=18080 # Bind to default port

      # i2p todo
      # tx-proxy=i2p,127.0.0.1:8060

      # node settings
      prune-blockchain=1
      db-sync-mode=safe # Slow but reliable db writes
      enforce-dns-checkpointing=1
      enable-dns-blocklist=1 # Block known-malicious nodes
      no-igd=true # Disable UPnP port mapping
      no-zmq=true # ZMQ configuration

      # bandwidth settings
      out-peers=32 # This will enable much faster sync and tx awareness; the default 8 is suboptimal nowadays
      in-peers=32 # The default is unlimited; we prefer to put a cap on this
      # \/ set by nixpkgs
      # limit-rate-up=1048576 # 1048576 kB/s == 1GB/s; a raise from default 2048 kB/s; contribute more to p2p network
      # limit-rate-down=1048576 # 1048576 kB/s == 1GB/s; a raise from default 8192 kB/s; allow for faster initial sync

      sync-pruned-blocks=1
      confirm-external-bind=1
    '';
  };

  services.journald.extraConfig = "SystemMaxUse=100M";
}
