{ ... }: {
  services.mattermost = {
    enable = true;
    siteUrl = "https://fedinet.org";
    mutableConfig = true;
    plugins = [ ./reactions.tar.gz ];
  };

  services.nginx.virtualHosts."fedinet.org" = {
    forceSSL = true; # Enforce SSL for the site
    enableACME = true; # Enable SSL for the site
    locations."/" = {
      proxyPass = "http://127.0.0.1:8065"; # Route to Mattermost
      proxyWebsockets = true;
    };
  };
}
