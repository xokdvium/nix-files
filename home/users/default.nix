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

  sergeiz = mkUser (let
    homeModule = _: {
      stylix = {
        autoEnable = false;
        targets = {
          kde.enable = false;
          gtk.enable = false;
        };
      };
    };
  in {
    name = "sergeiz";
    groups = ["wheel"];
    optionalGroups = ["docker" "networkmanager"];
    homeModules = [homeModule];
  });
}
