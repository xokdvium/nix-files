{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.extraOptions = {
    persistence.enable = lib.mkEnableOption "persistence";
  };

  config = let
    cfg = config.extraOptions.persistence;
  in
    lib.mkIf cfg.enable {
      home.persistence."/persistent/home/${config.home.username}" = {
        allowOther = true;
        # NOTE: Persist the whole nix cache directory to avoid redownloading flakes each time
        # https://www.reddit.com/r/NixOS/comments/j8porl/nix_flake_cache_directory_location/
        directories = [".cache/nix"];
      };
    };
}
