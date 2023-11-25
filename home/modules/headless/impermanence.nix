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
      };
    };
}
