{cfg, ...}: let
  upstreamConfig = builtins.readFile (builtins.fetchurl {
    url = "https://raw.githubusercontent.com/wazuh/wazuh/refs/tags/v${cfg.package.version}/etc/ossec-agent.conf";
    sha256 = "sha256:08lk72m2nacd1da78xjdw2vw9mvl0mbn6894s6zg1c80s9m9apvb";
  });

  substitutes = {
    "<address>IP</address>" = "<address>${cfg.managerIP}</address><port>${builtins.toString cfg.managerPort}</port>";
    "</ossec_config>" = "</ossec_config>\n${cfg.extraConfig}"; # TODO: should we assert finding new ossec_config tags in the extraConfig?

    # Replace syslog with journald
    # TODO: could we just add the journald log collector to the extraConfig section?
    "<log_format>syslog</log_format>" = "<log_format>journald</log_format>";
    "<location>/var/log/syslog</location>" = "<location>journald</location>";
    "<config-profile>debian, debian8</config-profile>" = "<config-profile>LinuxClients</config-profile>";
    "<network>yes</network>" = ''
      <network>yes</network>
      <packages>yes</packages>
      <hotfixes>yes</hotfixes>
    '';
  };
in
  builtins.replaceStrings (builtins.attrNames substitutes) (builtins.attrValues substitutes) upstreamConfig