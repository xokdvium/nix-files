{lib, ...}: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
    ];

    defaultGateway = "185.105.90.1";
    defaultGateway6 = {
      address = "2a09:5302:ffff::1";
      interface = "ens3";
    };

    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces = {
      ens3 = {
        ipv4.addresses = [
          {
            address = "185.105.90.23";
            prefixLength = 24;
          }
        ];

        ipv6.addresses = [
          {
            address = "2a09:5302:ffff::18c6";
            prefixLength = 48;
          }
          {
            address = "fe80::5054:ff:fe1a:da80";
            prefixLength = 64;
          }
        ];

        ipv4.routes = [
          {
            address = "185.105.90.1";
            prefixLength = 32;
          }
        ];

        ipv6.routes = [
          {
            address = "2a09:5302:ffff::1";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="52:54:00:1a:da:80", NAME="ens3"

  '';
}
