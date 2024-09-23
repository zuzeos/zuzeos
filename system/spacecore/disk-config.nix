{
  disko.devices = {
    disk = {
      x = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD5003ABYX-18WERA0_WD-WMAYP0K1HDY1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "64M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      y = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD5003ABYX-18WERA0_WD-WMAYP0K7UT6P";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
          mountpoint = "none";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/secret.key";
        };
        postCreateHook = ''
          zfs set keylocation="prompt" "zroot";
          zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank
        '';

        datasets = {
          root = {
            type = "zfs_fs";
            options.mountpoint = "none";
            # options."com.sun:auto-snapshot" = "true";
          };
          "root/nixos" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
          };
        };
      };
    };
  };
}

