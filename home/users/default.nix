{lib, ...}: let
  inherit (lib) mkUser;
in {
  xokdvium = mkUser (let
    homeModule = _: {
      stylix.autoEnable = true;
    };
  in {
    name = "xokdvium";
    normalUser = true;
    groups = ["wheel"];
    optionalGroups = ["docker" "networkmanager" "wireshark"];
    homeModules = [homeModule];
  });

  admin = mkUser {
    name = "admin";
    normalUser = true;
    groups = ["wheel"];
    optionalGroups = ["networkmanager"];
    homeModules = [];
  };
}
