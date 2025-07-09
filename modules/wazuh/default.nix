{
  config,
  lib,
  pkgs,
  ...
}: let
  wazuhUser = "wazuh";
  wazuhGroup = wazuhUser;
  stateDir = "/var/ossec";
  cfg = config.services.wazuh-agent;
  pkg = config.services.wazuh-agent.package;
  generatedConfig = import ./generate-agent-config.nix {
    cfg = config.services.wazuh-agent;
    inherit pkgs;
  };
in {
  options = {
    services.wazuh-agent = {
      enable = lib.mkEnableOption "Wazuh agent";

      managerIP = lib.mkOption {
        type = lib.types.nonEmptyStr;
        description = ''
          The IP address or hostname of the manager.
        '';
        example = "192.168.1.2";
      };

      managerPort = lib.mkOption {
        type = lib.types.port;
        description = ''
          The port the manager is listening on to receive agent traffic.
        '';
        example = 1514;
        default = 1514;
      };

      package = lib.mkPackageOption pkgs "wazuh-agent" {};

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        description = ''
          Extra configuration values to be appended to the bottom of ossec.conf.
        '';
        default = "";
        example = ''
          <!-- The added ossec_config root tag is required -->
          <ossec_config>
            <!-- Extra configuration options as needed -->
          </ossec_config>
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${wazuhUser} = {
      isSystemUser = true;
      group = wazuhGroup;
      description = "Wazuh daemon user";
      home = stateDir;
    };

    users.groups.${wazuhGroup} = {};

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0750 ${wazuhUser} ${wazuhGroup}"
    ];

    systemd.services.wazuh-agent = {
      path = [
        "/run/current-system/sw"
      ];
      description = "Wazuh agent";
      wants = ["network-online.target"];
      after = ["network.target" "network-online.target"];
      wantedBy = ["multi-user.target"];

      preStart = ''
        # Create required directories and set ownership
        mkdir -p ${stateDir}/{etc/shared,queue,var,wodles,logs,lib,tmp,agentless,active-response}
        find ${stateDir} -type d -exec chmod 750 {} \;
        chown -R ${wazuhUser}:${wazuhGroup} ${stateDir}

        # Generate and copy ossec.config
        cp ${pkgs.writeText "ossec.conf" generatedConfig} ${stateDir}/etc/ossec.conf

        cp -r ${pkg}/bin/ ${stateDir}
      '';

      serviceConfig = {
        Type = "forking";
        WorkingDirectory = "${stateDir}/bin";
        ExecStart = "${stateDir}/bin/wazuh-control start";
        ExecStop = "${stateDir}/bin/wazuh-control stop";
        ExecReload = "${stateDir}/bin/wazuh-control reload";
        KillMode = "process";
        RemainAfterExit = "yes";
      };
    };
  };
}
