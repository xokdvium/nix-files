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
    mutableUsers = false;

    users =
      genUsers
      (user: {
        isNormalUser = user.normalUser;
        home = user.homePath;

        extraGroups =
          user.groups
          ++ ifTheyExist user.optionalGroups;

        shell = lib.mkOverride 75 pkgs.zsh; # FIXME: Maybe move this somewhere else
        hashedPasswordFile = config.sops.secrets."passwords/${user.name}".path;
      })
      // {
        root.hashedPasswordFile = config.sops.secrets."passwords/root".path;
      };
  };

  sops.secrets =
    lib.genAttrs (builtins.map (name: "passwords/${name}")
      (
        (builtins.attrNames extraConfig.users)
        ++ ["root"]
      ))
    (_: {
      sopsFile = extraConfig.host.secretsFile;
      neededForUsers = true;
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
