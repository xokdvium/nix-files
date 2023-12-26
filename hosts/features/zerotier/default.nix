_: let
  networkId = "a09acf023353c355";
in {
  services = {
    zerotierone = {
      enable = true;
      joinNetworks = [networkId];
    };

    resolved = {
      enable = true;
    };
  };
}
