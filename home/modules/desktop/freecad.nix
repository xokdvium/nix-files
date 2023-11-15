{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    freecad
  ];

  home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.persistence.enable {
    directories = [".config/FreeCAD"];
  };
}
