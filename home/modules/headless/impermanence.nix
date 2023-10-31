{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options = {
    persistence.enable = lib.mkEnableOption "persistence";
  };

  config = let
    cfg = config.persistence;
  in
    lib.mkIf cfg.enable {
      home.persistence."/persistent/home/${config.home.username}" = {
        directories = [
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          "Work"
        ];

        allowOther = true;
      };
    };
}
