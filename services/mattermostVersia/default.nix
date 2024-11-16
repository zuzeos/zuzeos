{ ... }: {
  services.mattermost = {
    enable = true;
    siteUrl = "https://mm.versia.pub";
    mutableConfig = true;
    plugins = [ ../mattermost/reactions.tar.gz ];
  };

  services.nginx.virtualHosts."mm.versia.pub" = {
    forceSSL = true; # Enforce SSL for the site
    enableACME = true; # Enable SSL for the site
    locations."/" = {
      proxyPass = "http://127.0.0.1:8065"; # Route to Mattermost
      proxyWebsockets = true;
    };
  };
}
