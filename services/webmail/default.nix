{ config, pkgs, lib, ... }:

with lib;

{
  services.roundcube = {
     enable = true;
     # this is the url of the vhost, not necessarily the same as the fqdn of
     # the mailserver
     hostName = "mail.versia.pub";
     extraConfig = ''
       # starttls needed for authentication, so the fqdn required to match
       # the certificate
       $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
       $config['smtp_user'] = "%u";
       $config['smtp_pass'] = "%p";
     '';
  };

  services.nginx.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
