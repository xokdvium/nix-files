{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    cura
  ];

  home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.extraOptions.persistence.enable {
    directories = [
      ".config/cura"
      ".local/share/cura"
    ];
  };
}
