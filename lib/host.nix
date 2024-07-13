{ inputs, outputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  mkHostInfo =
    {
      system,
      homeModules ? [ ],
      nixosModules,
      disk ? null,
      secretsFile ? null,
    }:
    {
      inherit
        system
        homeModules
        disk
        secretsFile
        ;

      nixosModules =
        nixosModules
        ++ [ inputs.home-manager.nixosModules.home-manager ]
        ++ builtins.attrValues outputs.nixosModules;
    };

  mkHostSystem =
    {
      modules ? [ ],
      host,
      users ? { },
      additionalSpecialArgs ? { },
    }:
    let
      extraConfig = {
        inherit host users;
      };
    in
    lib.nixosSystem {
      inherit (host) system;
      modules = modules ++ host.nixosModules;
      specialArgs = {
        inherit inputs outputs extraConfig;
      } // additionalSpecialArgs;
    };

  mkHostImage =
    {
      modules ? [ ],
      host,
      users,
      format,
      additionalSpecialArgs ? { },
    }:
    let
      extraConfig = {
        inherit host users;
      };
    in
    inputs.nixos-generators.nixosGenerate {
      inherit (host) system;
      inherit format;
      modules = modules ++ host.nixosModules;
      specialArgs = {
        inherit inputs outputs extraConfig;
      } // additionalSpecialArgs;
    };
}
