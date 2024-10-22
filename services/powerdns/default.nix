{ ... }: {
  services.powerdns = {
    enable = true;
    extraConfig = ''
      loglevel = 4
      resolver = 9.9.9.9
      rng=urandom
      expand-alias = yes
      outgoing-axfr-expand-alias = yes

      autosecondary = yes
      workaround-11804=yes

      default-ksk-algorithm = ed25519
      default-zsk-algorithm = ed25519

      # ns1.homecloud.lol
      allow-axfr-ips    = 217.69.6.150,2a05:f480:1c00:7f:5400:5ff:fe05:75e3
      allow-notify-from = 217.69.6.150,2a05:f480:1c00:7f:5400:5ff:fe05:75e3
      also-notify       = 217.69.6.150,2a05:f480:1c00:7f:5400:5ff:fe05:75e3

      # miyuki.sakamoto.pl
      allow-axfr-ips    += 5.78.65.112,2a01:4ff:1f0:f98::
      allow-notify-from += 5.78.65.112,2a01:4ff:1f0:f98::
      also-notify       += 5.78.65.112,2a01:4ff:1f0:f98::

      # ns1.famfo.xyz
      allow-axfr-ips    += 116.202.10.127,2a01:4f8:c012:fb3::1
      allow-notify-from += 116.202.10.127,2a01:4f8:c012:fb3::1
      also-notify       += 116.202.10.127,2a01:4f8:c012:fb3::1

      # ns2.famfo.xyz
      allow-axfr-ips    += 150.107.200.153,2406:ef80:4:2afe::1
      allow-notify-from += 150.107.200.153,2406:ef80:4:2afe::1
      also-notify       += 150.107.200.153,2406:ef80:4:2afe::1

      # sakamoto.pl
      allow-axfr-ips    += 185.236.240.103,2a0d:eb00:8006::acab
      allow-notify-from += 185.236.240.103,2a0d:eb00:8006::acab
      also-notify       += 185.236.240.103,2a0d:eb00:8006::acab

      # ns1.fops.at
      allow-axfr-ips    += 176.126.242.104,2a00:1098:37a::2
      allow-notify-from += 176.126.242.104,2a00:1098:37a::2
      also-notify       += 176.126.242.104,2a00:1098:37a::2

      # ns7.kytta.dev
      allow-axfr-ips    += 185.154.195.110,2a03:6f00:4::78ec
      allow-notify-from += 185.154.195.110,2a03:6f00:4::78ec
      also-notify       += 185.154.195.110,2a03:6f00:4::78ec

      #setgid = pdns
      #setuid = pdns

      webserver = yes
      webserver-port = 8053
      webserver-allow-from = 192.168.0.0/16
      webserver-address = 192.168.69.126
      api = yes

      launch = gsqlite3
      gsqlite3-database = /var/lib/pdns/pdns.sqlite3
      gsqlite3-dnssec = yes

      default-soa-content = nsfrah.aprilthe.pink. dns-is-borkd.sdomi.pl 300 10800 3600 604800 3600

      # Refrence: https://doc.powerdns.com/authoritative/settings.html
      # Dump all opitons (including default values): pdns_control current-config

      local-address = ::1, 192.168.69.126
      version-string = sf-aprlI
      loglevel-show = yes
      #loglevel = 7
      primary = yes
      secondary = yes
      default-soa-edit = INCEPTION-INCREMENT
    '' ;
    secretFile = "/run/keys/powerdns.env";
  };
}
