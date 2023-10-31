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
    optionalGroups = ["docker" "networkmanager"];
    homeModules = [homeModule];
  });
}
