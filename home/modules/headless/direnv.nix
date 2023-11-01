{
  config,
  lib,
  ...
}: {
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.persistence.enable {
    directories = [
      ".local/share/direnv"
    ];
  };
}
