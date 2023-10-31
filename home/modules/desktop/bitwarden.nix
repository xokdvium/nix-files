{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    bitwarden
  ];

  home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.persistence.enable {
    directories = [".config/Bitwarden"];
  };
}
