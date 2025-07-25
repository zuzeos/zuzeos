{cfg, ...}: let
  upstreamConfig = builtins.readFile (builtins.fetchurl {
    url = "https://raw.githubusercontent.com/wazuh/wazuh/refs/tags/v${cfg.package.version}/etc/ossec-agent.conf";
    sha256 = "sha256-a1+VatIAsfC+0SQhY1cFdNfEt+BNdnRUC40pK6o4kyI=";
  });

  substitutes = {
    "<address>IP</address>" = "<address>${cfg.managerIP}</address><port>${builtins.toString cfg.managerPort}</port>";
    "</ossec_config>" = "</ossec_config>\n${cfg.extraConfig}"; # TODO: should we assert finding new ossec_config tags in the extraConfig?

    # Replace syslog with journald
    # TODO: could we just add the journald log collector to the extraConfig section?
    "<log_format>syslog</log_format>" = "<log_format>journald</log_format>";
    "<location>/var/log/syslog</location>" = "<location>journald</location>";
    "<config-profile>debian, debian8</config-profile>" = "<config-profile>LinuxClients</config-profile>";
  };
in
  builtins.replaceStrings (builtins.attrNames substitutes) (builtins.attrValues substitutes) upstreamConfig