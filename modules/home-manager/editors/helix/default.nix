{
  pkgs,
  lib,
  outputs,
  config,
  ...
}:
let
  inherit (outputs.lib) mkHomeCategoryModuleEnableOption;

  correctScheme = pkgs.runCommand "helix-stylix-theme-patched" { } ''
    cp ${config.xdg.configFile."helix/themes/stylix.toml".source} $out
    substituteInPlace $out --replace-fail '"ui.virtual.inlay-hint" = { fg = "base01" }' '"ui.virtual.inlay-hint" = { fg = "base06" }'
  '';

  helixConfig = {
    enable = true;

    settings = {
      theme = lib.mkForce "stylix-patched";
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
          enable = true;
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
            xdg.configFile."helix/themes/stylix-patched.toml".source = correctScheme;
          }
        ]
        ++ (import ./languages { inherit pkgs; })
      )
    );
}
