{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    obsidian
  ];

  home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.extraOptions.persistence.enable {
    directories = [".config/Obsidian"];
  };
}
