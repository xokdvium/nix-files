{
  lib,
  config,
  ...
}: {
  programs.alacritty = {
    enable = true;

    settings = {
      shell = {
        program = "${config.programs.tmux.shell}";
        args = let
          tmux = "${config.programs.tmux.package}/bin/tmux";
        in [
          "-l"
          "-c"
          "${tmux} attach || ${tmux}"
        ];
      };
    };
  };

  stylix.targets.alacritty.enable = lib.mkDefault true;
}
