{ lib, ... }:
let
  inherit (lib) mkUser;
in
{
  xokdvium = mkUser {
    name = "xokdvium";
    normalUser = true;
    groups = [ "wheel" ];
    optionalGroups = [
      "docker"
      "networkmanager"
      "wireshark"
      "keys"
    ];
    homeModules = [ ];
  };

  admin = mkUser {
    name = "admin";
    normalUser = true;
    groups = [ "wheel" ];
    optionalGroups = [ "networkmanager" ];
    homeModules = [ ];
  };

  builder = mkUser {
    name = "builder";
    normalUser = false;
    group = "builder";
    groups = [ ];
    homePath = "/var/empty";
    optionalGroups = [ ];
    homeModules = [ ];
  };
}
