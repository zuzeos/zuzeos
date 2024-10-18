{ config, ... }: {
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];

  services.netbox = {
    enable = true;
    secretKeyFile = "/var/lib/netbox/secret-key-file";
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedZstdSettings = true;
    recommendedBrotliSettings = true;
    clientMaxBodySize = "25m";

    user = "netbox";

    virtualHosts."netbox.${config.networking.fqdn}" = {
      locations = {
        "/" = {
          proxyPass = "http://[::1]:8001";
          # proxyPass = "http://${config.services.netbox.listenAddress}:${config.services.netbox.port}";
        };
        "/static/" = { alias = "${config.services.netbox.dataDir}/static/"; };
      };
      forceSSL = true;
      enableACME = true;
      serverName = "netbox.${config.networking.fqdn}";
    };
  };

  security.acme = {
    defaults.email = "acme@${config.networking.domain}";
    acceptTerms = true;
  };
}
