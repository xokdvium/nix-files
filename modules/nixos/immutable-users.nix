{
  config,
  extraConfig,
  lib,
  outputs,
  ...
}: let
  genUsers = outputs.lib.genUsers extraConfig.users;
  cfg = config.extraOptions.immutableUsers;
in {
  options.extraOptions.immutableUsers = {
    enable = lib.mkEnableOption "immutableUsers";
  };

  config = lib.mkIf cfg.enable {
    users = {
      mutableUsers = lib.mkDefault false;

      users = let
        sopsSecrets = config.sops.secrets;
      in (
        genUsers
        (user: {
          hashedPasswordFile = sopsSecrets."passwords/${user.name}".path;
        })
        // {
          root.hashedPasswordFile = sopsSecrets."passwords/root".path;
        }
      );
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
  };
}
