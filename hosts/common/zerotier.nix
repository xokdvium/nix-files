{
  pkgs,
  lib,
  ...
}: {
  services.zerotierone = {
    enable = true;
    joinNetworks = ["a09acf023353c355"];
  };
}
