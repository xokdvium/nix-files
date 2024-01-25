{
  inputs,
  outputs,
  ...
}: let
  lib = inputs.nixpkgs.lib;
in rec {
  mkHomeDir = user: "/home/${user}";

  mkHomeConfiguration = {
    modules ? [],
    user,
    host,
    additionalSpecialArgs ? {},
  }:
    inputs.home-manager.lib.homeManagerConfiguration (let
      inherit (inputs) nixpkgs;
      extraConfig = {
        inherit host;
        users = {"${user.name}" = user;};
      };

      userSettingModule = _: {
        home.username = user.name;
      };
    in {
      modules =
        builtins.attrValues outputs.homeManagerModules
        ++ modules
        ++ host.homeModules
        ++ [
          userSettingModule
        ];

      pkgs = nixpkgs.legacyPackages.${host.system};
      extraSpecialArgs = {inherit inputs outputs extraConfig;} // additionalSpecialArgs;
    });

  mkUser = {
    name,
    homePath ? mkHomeDir name,
    groups ? [],
    optionalGroups ? [],
    normalUser ? true,
    homeModules ? [],
  }: {
    inherit
      name
      groups
      optionalGroups
      homePath
      normalUser
      ;

    homeModules = homeModules ++ builtins.attrValues outputs.homeManagerModules;
  };

  genUsers = users: f: (
    inputs.nixpkgs.lib.genAttrs
    (builtins.attrNames users)
    (name: f (builtins.getAttr name users))
  );

  mkHomeCategoryModuleEnableOption = config: {
    category,
    name,
    autoEnable ? true,
  }:
    lib.mkOption {
      description = "Enable home module ${name} from ${category} category";
      type = lib.types.bool;
      default = config.xokdvium.home.${category}.enable && autoEnable;
    };

  # NOTE: Such a category can look something like:
  # options.xokdvium.home.headless = {
  #   enable = mkHomeCategoryEnableOption "headless";
  # }
  mkHomeCategoryEnableOption = name:
    lib.mkOption {
      description = "Enable all home modules ${name} category";
      type = lib.types.bool;
      default = false;
    };
}
