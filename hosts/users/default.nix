{lib, ...}: let
  inherit (lib) mkUser;
in {
  xokdvium = mkUser {
    name = "xokdvium";
    normalUser = true;
    groups = ["wheel"];
    optionalGroups = ["docker" "networkmanager" "wireshark"];
    homeModules = [];
  };

  admin = mkUser {
    name = "admin";
    normalUser = true;
    groups = ["wheel"];
    optionalGroups = ["networkmanager"];
    homeModules = [];
  };

  builder = mkUser {
    name = "builder";
    normalUser = true;
    groups = [];
    optionalGroups = [];
    homeModules = [];
  };
}
