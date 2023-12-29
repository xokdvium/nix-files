{lib, ...}: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
    ];

    defaultGateway = "185.233.82.1";
    defaultGateway6 = {
      address = "2a04:5201:2::1";
      interface = "ens3";
    };

    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces = {
      ens3 = {
        ipv4.addresses = [
          {
            address = "185.233.82.112";
            prefixLength = 24;
          }
        ];

        ipv6.addresses = [
          {
            address = "2a04:5201:2::6c6";
            prefixLength = 48;
          }
          {
            address = "fe80::5054:ff:fe3b:a606";
            prefixLength = 64;
          }
        ];

        ipv4.routes = [
          {
            address = "185.233.82.1";
            prefixLength = 32;
          }
        ];

        ipv6.routes = [
          {
            address = "2a04:5201:2::1";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="52:54:00:3b:a6:06", NAME="ens3"

  '';
}
