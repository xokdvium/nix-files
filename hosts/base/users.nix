{
  config,
  lib,
  extraConfig,
  inputs,
  outputs,
  pkgs,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

  genUsers = outputs.lib.genUsers extraConfig.users;
  genNormalUsers = outputs.lib.genUsers (lib.filterAttrs (_: v: v.normalUser) extraConfig.users);
in
{
  programs.zsh.enable = true;
  users = {
    users = genUsers (user: {
      isNormalUser = user.normalUser;
      isSystemUser = !user.normalUser;
      home = user.homePath;
      uid = user.uid;
      group = lib.mkIf (!builtins.isNull user.group) user.group;
      extraGroups = user.groups ++ ifTheyExist user.optionalGroups;

      shell = lib.mkOverride 75 pkgs.zsh; # FIXME: Maybe move this somewhere else
    });
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs extraConfig;
    };

    users = genNormalUsers (user: {
      imports = user.homeModules ++ extraConfig.host.homeModules;
      home.username = user.name;
    });
  };
}
