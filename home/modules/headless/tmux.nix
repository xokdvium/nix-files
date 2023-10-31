{
  pkgs,
  config,
  ...
}: {
  programs = {
    tmux = {
      enable = true;
      shell = "${config.programs.zsh.package}/bin/zsh";
      newSession = true;
      escapeTime = 0;
    };

    fzf.tmux = {
      enableShellIntegration = true;
    };
  };
}
