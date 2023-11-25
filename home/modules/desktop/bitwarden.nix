{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    bitwarden
  ];

  home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.extraOptions.persistence.enable {
    directories = [".config/Bitwarden"];
  };
}
