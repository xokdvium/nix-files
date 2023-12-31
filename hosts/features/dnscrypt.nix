{lib, ...}: let
  address4 = "127.0.0.1";
  address6 = "::1";
in {
  systemd = {
    network = {
      enable = true;
      wait-online.enable = false;
    };
  };

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      upstreamDefaults = true;
      settings = {
        listen_addresses = ["${address4}:53" "[${address6}]:53"];
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];

          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
      };
    };

    # FIXME: Revisit this issue:
    # At the time of September 2023, systemd upstream advise to disable DNSSEC by default
    # as the current code is not robust enough to deal with “in the wild” non-compliant servers,
    # which will usually give you a broken bad experience in addition of insecure.
    resolved = {
      enable = true;
      dnssec = "false";
      llmnr = "true";
    };
  };

  networking = {
    nameservers = [address4 address6];
  };

  environment.etc = {
    # NOTE: This is necessary to prevent NetworkManager from pushing DNS servers acquired through DHCP to systemd-resolved.
    # https://wiki.archlinux.org/title/NetworkManager#Unit_dbus-org.freedesktop.resolve1.service_not_found
    # https://bbs.archlinux.org/viewtopic.php?id=248158
    "NetworkManager/conf.d/no-systemd-resolved.conf".text = ''
      [main]
      dns=none
      systemd-resolved=false
    '';
  };
}
