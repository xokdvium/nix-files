{ pkgs, ... }:

let
  address4 = "127.0.0.1";
  address6 = "::1";
  logDir = "/var/log/dnscrypt-proxy";
  mkLogFile = file: "${logDir}/${file}";
in

{
  imports = [ ./systemd-networkd.nix ];

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      upstreamDefaults = true;
      settings = {
        listen_addresses = [
          "${address4}:53"
          "[${address6}]:53"
        ];
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];

          cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };

        query_log.file = mkLogFile "query.log";
        nx_log.file = mkLogFile "nx.log";
        log_file = mkLogFile "dnscrypt-proxy.log";
        log_level = 0;

        # FIXME: Find a way to not hardcode the default gateway address here
        forwarding_rules =
          let
            defaultGateway = "192.168.50.1";
            backupDns = "8.8.8.8";
          in
          # FIXME: For whatever reason github.com does not always loads correctly.
          # For the moment the fix seems to be to forward queries to a plain DNS server.
          pkgs.writeText "dnscrypt-proxy2-forwarding-lan" ''
            aeronas.lan ${defaultGateway}
            router.asus.com ${defaultGateway}
            github.com ${backupDns}
          '';
      };
    };
  };

  networking = {
    nameservers = [
      address4
      address6
    ];
  };

  environment = {
    etc = {
      # NOTE: This is necessary to prevent NetworkManager from pushing DNS servers acquired through DHCP to systemd-resolved.
      # https://wiki.archlinux.org/title/NetworkManager#Unit_dbus-org.freedesktop.resolve1.service_not_found
      # https://bbs.archlinux.org/viewtopic.php?id=248158
      "NetworkManager/conf.d/no-systemd-resolved.conf".text = ''
        [main]
        dns=none
        systemd-resolved=false
      '';
    };
  };
}
