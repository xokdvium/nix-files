{
  config,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        mouse = false;
        auto-format = true;
        auto-save = true;

        file-picker = {
          hidden = false;
          git-ignore = true;
        };

        rulers = [
          80
          120
        ];

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        indent-guides = {
          render = true;
          character = "┆";
          skip-levels = 1;
        };

        whitespace = {
          render = {
            space = "none";
            tab = "all";
            newline = "all";
            nbsp = "all";
          };

          characters = {
            space = "·";
            nbsp = "+";
            tab = "→";
            newline = "↵";
            tabpad = "·";
          };
        };
      };

      keys = {
        normal = {
          C-s = ":w";
        };
      };
    };
  };

  stylix.targets.helix = {
    enable = true;
  };

  # FIXME: Hacky workaround to make Gnome accept session variables
  programs.zsh.envExtra = ''
    EDITOR=${config.programs.helix.package}/bin/hx
  '';
}
