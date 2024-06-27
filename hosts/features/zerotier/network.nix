{ lib, config, ... }:

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

  environment.persistence."/persistent" = lib.mkIf config.xokdvium.nixos.persistence.enable {
    directories = [ "/var/lib/zerotier-one" ];
  };
}
