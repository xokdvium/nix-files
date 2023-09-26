{
  pkgs,
  config,
  ...
}: let
  ifTheyExist = groups:
    builtins.filter
    (group: builtins.hasAttr group config.users.groups)
    groups;
in {
  users = {
    users.xokdvium = {
      isNormalUser = true;
      home = "/home/xokdvium";
      extraGroups =
        [
          "wheel"
        ]
        ++ ifTheyExist [
          "docker"
          "networkmanager"
        ];

      packages = with pkgs; [
        home-manager
      ];
    };
  };

  home-manager.users.xokdvium = let
    hostname = config.networking.hostName;
  in
    import ../../../../home/xokdvium/${hostname}.nix;
}
