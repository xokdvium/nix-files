{
  inputs,
  outputs,
  ...
}: rec {
  mkHomeDir = user: "/home/${user}";

  mkHomeConfiguration = {
    modules ? [],
    user,
    host,
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
      extraSpecialArgs = {inherit inputs outputs extraConfig;};
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
}
