{
  config,
  lib,
  extraConfig,
  inputs,
  outputs,
  pkgs,
  ...
}: let
  ifTheyExist = groups:
    builtins.filter
    (group: builtins.hasAttr group config.users.groups)
    groups;

  genUsers = f:
    lib.genAttrs (builtins.attrNames
      extraConfig.users)
    (name: f (builtins.getAttr name extraConfig.users));
in {
  programs.zsh.enable = true;

  users.users =
    genUsers
    (user: {
      isNormalUser = user.normalUser;
      home = user.homePath;

      extraGroups =
        user.groups
        ++ ifTheyExist user.optionalGroups;

      shell = lib.mkOverride 75 pkgs.zsh; # FIXME: Maybe move this somewhere else
    });

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs extraConfig;
    };

    users = genUsers (
      user: {
        imports = user.homeModules ++ extraConfig.host.homeModules;
        home.username = user.name;
      }
    );
  };
}
