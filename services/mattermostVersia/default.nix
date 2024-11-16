{ pkgs, ... }: {
  services.mattermost = {
    enable = true;
    package = pkgs.mattermost.overrideAttrs ({ patches ? [], ...}: {
      patches = patches ++ [
        ./d1.patch
        ./d2.patch
        ./d3.patch
      ];
      src = pkgs.fetchFromGitHub {
        owner = "mattermost";
        repo = "mattermost";
        rev = "d6a89c69c210f9e86b45b15bb867b7d02b3e10b8";
        hash = "sha256-wJknX+jHxy7ROX9ECB87LUC8vQSbZym6qYLqHpGXv4Q=";
      };
      vendorHash = "sha256-G2IhU8/XSITjJKNu1Iwwoabm+hG9r3kLPtZnlzuKBD8=";
    });
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
