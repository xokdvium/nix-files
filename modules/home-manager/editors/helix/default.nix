{
  pkgs,
  lib,
  outputs,
  config,
  ...
}:
let
  inherit (outputs.lib) mkHomeCategoryModuleEnableOption;

  helixConfig = {
    enable = true;

    settings = {
      editor = {
        mouse = false;
        line-number = "relative";
        auto-format = true;
        auto-save = true;
        bufferline = "multiple";

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

        smart-tab = {
          enable = false;
        };

        search = {
          smart-case = true;
          wrap-around = false;
        };

        soft-wrap = {
          enable = false;
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };
    };
  };
in
{
  options.xokdvium.home.editors = {
    helix.enable = mkHomeCategoryModuleEnableOption config {
      name = "helix";
      category = "editors";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.editors.helix;
    in
    lib.mkIf cfg.enable (
      lib.mkMerge (
        [
          {
            programs.helix = helixConfig;
            home.sessionVariables = {
              EDITOR = "${config.programs.helix.package}/bin/hx";
            };
          }
        ]
        ++ (import ./languages { inherit pkgs; })
      )
    );
}
