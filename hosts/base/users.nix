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

  genUsers = outputs.lib.genUsers extraConfig.users;
in {
  programs.zsh.enable = true;
  users = {
    users =
      genUsers
      (user: {
        isNormalUser = user.normalUser;
        home = user.homePath;

        extraGroups =
          user.groups
          ++ ifTheyExist user.optionalGroups;

        shell = lib.mkOverride 75 pkgs.zsh; # FIXME: Maybe move this somewhere else
      });
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs extraConfig;
      homeModulesPath = "${inputs.self}/home/modules";
    };

    users = genUsers (
      user: {
        imports = user.homeModules ++ extraConfig.host.homeModules;
        home.username = user.name;
      }
    );
  };
}
