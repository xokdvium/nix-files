{
  lib,
  config,
  ...
}: let
  networkId = "a09acf023353c355";
in {
  services = {
    zerotierone = {
      enable = true;
      joinNetworks = [networkId];
    };
  };

  environment.persistence."/persistent" = lib.mkIf config.extraOptions.persistence.enable {
    directories = ["/var/lib/zerotier-one"];
  };
}
