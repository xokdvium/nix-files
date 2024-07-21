{ lib, ... }:

{
  networking = {
    networkmanager.enable = lib.mkOverride 75 true;
    wireless.enable = lib.mkOverride 75 false;
  };

  xokdvium.nixos.persistence = {
    persist.dirs = [ "/etc/Network/Manager" ];
  };
}
