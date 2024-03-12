{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  options.xokdvium.home = {
    persistence.enable = lib.mkEnableOption "persistence";
  };

  config =
    let
      cfg = config.xokdvium.home.persistence;
    in
    lib.mkIf cfg.enable {
      home.persistence = {
        "/state/home/${config.home.username}" = {
          allowOther = true;
        };
        "/persistent/home/${config.home.username}" = {
          allowOther = true;
          # NOTE: Persist the whole nix cache directory to avoid redownloading flakes each time
          # https://www.reddit.com/r/NixOS/comments/j8porl/nix_flake_cache_directory_location/
          directories = [ ".cache/nix" ];
        };
      };
    };
}
