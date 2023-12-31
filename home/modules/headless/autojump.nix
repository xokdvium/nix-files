{
  config,
  lib,
  ...
}: {
  programs.autojump = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.extraOptions.persistence.enable {
    directories = [".local/share/autojump"];
  };
}
