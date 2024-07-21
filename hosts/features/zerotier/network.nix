let
  networkId = "a09acf023353c355";
in

{
  services = {
    zerotierone = {
      enable = true;
      joinNetworks = [ networkId ];
      localConf = {
        settings.allowTcpFallbackRelay = true;
      };
    };
  };

  xokdvium.nixos.persistence = {
    persist.dirs = [ "/var/lib/zerotier-one" ];
  };
}
