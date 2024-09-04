{ lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../baseconf.nix
    ../../disk-config.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "moralitycore";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPKL1+FX6pt3EasE9ZIb9Qg+LvFVagAVi2Uy9X2E90n aprl@acab.dev"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxsX+lEWkHZt9NOvn9yYFP0Z++186LY4b97C4mwj/f2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpyVefbZLkNVNzdSIlO6x6JohHE1snoHiUB3Qdvl5I2"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0v3tUBNEUxfoOQBFb+N2DUBQDay0iFggUWa9Nd+BtFLOKkz+RRto3eBF0ZiJZVUxv/hLb8m2s45hcMw8agwuPrXMe5085T1fzkvPdKAPZdsT/cCmBi1OsoLjAKBFIdM4lcV0A2cca8hip+/ZPpjFPUWx73/672gAPHU7co7fP8+8CSf9dx+WIeLx3yaYHYZ/th3dB5auX3VjOazS8MojsAorwTUeBoPamHQ5dFeNafhFUL/hhtGkUI1cNHUn3bJd2V7AKTW3UglK7hVgMJPrzVS31OlpcJEf6S5XgKTWdOSwubn1bs5Lt6YYRDU24NV6CGrwKgCJSRxzNMLwpnFKiSXpO8FzkqWHYWyju141hQcFF31aZIV+7YcwEt5ZukLjFOpVtpbSXvJYigOUzGi34P3/OAGshDXjTQjvM8GIir49gx3b2Nwhg0z4UHBkAKZvDDFPHDMJoclvnhITojaAojfC9zmMCO5ZaEsk8yv7c/lWQumzRpfldWF4mwHvhD5kTADbhRdO7WTdX7AaiAYINooToeWKjFe2wn3rFubPUppptqtP03mmvs7vhhgnEVBbGZRJK3GTVk1XcsfF9rDKzewSa+wb4LsBoZtFRhc8cJqHGlKWSNk7dQ04B1atPyNLKGpGoo/UIPxyZ6bSqFVxY3nhz46VZ6z8XWI48z0/fRQ=="
  ];

  #services.lysand.ap = {
  #  enable = true;
  #  domain = "lysand.fediverse.gay";
  #  nginx.enable = true;
  #};

  services.postgresql.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "aprl@acab.dev";
  };

  services.mattermost = {
    enable = true;
    siteUrl = "https://mm.versia.pub";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;    
    virtualHosts = {
      # Replace with the domain from your siteUrl
      "mm.versia.pub" = {
        forceSSL = true; # Enforce SSL for the site
        enableACME = true; # Enable SSL for the site
        locations."/" = {
          proxyPass = "http://127.0.0.1:8065"; # Route to Mattermost
          proxyWebsockets = true;
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];
  
  system.stateVersion = "23.11";
}
