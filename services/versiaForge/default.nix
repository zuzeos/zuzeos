{ pkgs, config, ...}: 
let
  cfg = config.services.forgejo;
  srv = config.services.forgejo.settings.server;
in
{
  services.nginx = {
    virtualHosts.${cfg.settings.server.DOMAIN} = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations."/".proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
    };
  };

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "forge.versia.pub";
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${srv.DOMAIN}/"; 
        HTTP_PORT = 3000;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = false; 
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
      # Sending emails is completely optional
      # You can send a test email from the web UI at:
      # Profile Picture > Site Administration > Configuration >  Mailer Configuration 
      mailer = {
        ENABLED = true;
        SMTP_ADDR = "mail.versia.pub";
        FROM = "noreply@versia.pub";
        USER = "noreply@versia.pub";
      };
    };
    mailerPasswordFile = "/etc/nixos/secrets/noreply-pass";
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-actions-runner;
    instances.default = {
      enable = true;
      name = "monolith";
      url = "https://forge.versia.pub";
      # Obtaining the path to the runner token file may differ
      # tokenFile should be in format TOKEN=<secret>, since it's EnvironmentFile for systemd
      tokenFile = "/opt/forge_runner_token";
      labels = [
        "ubuntu-latest:docker://node:23-bookworm"
        "ubuntu-22.04:docker://node:23-bullseye"
        "ubuntu-20.04:docker://node:23-bullseye"
        "ubuntu-18.04:docker://node:23-buster"     
        ## optionally provide native execution on the host:
        # "native:host"
      ];
    };
  };
}