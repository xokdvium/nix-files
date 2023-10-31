{pkgs, ...}: {
  programs.helix = {
    enable = true;

    languages = {
      language-server = {
        clangd = {
          command = "${pkgs.clang-tools_16}/bin/clangd";
          args = ["--header-insertion=never"];
        };

        nil = {
          command = "${pkgs.nil}/bin/nil";
          args = ["--stdio"];
        };

        statix = {
          command = "${pkgs.statix}/bin/statix";
          args = ["check" "--stdin"];
        };

        bash-language-server = {
          command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
        };

        cmake-language-server = {
          command = "${pkgs.cmake-language-server}/bin/cmake-language-server";
        };

        taplo = {
          command = "${pkgs.taplo}/bin/taplo";
          args = ["lsp" "stdio"];
        };

        yaml-language-server = {
          command = "${pkgs.nodePackages_latest.yaml-language-server}/bin/yaml-language-server";
          args = ["--stdio"];
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
          language-servers = ["nil" "statix"];
        }
        {
          name = "yaml";
          file-types = ["yml" "yaml"];
          auto-format = true;
          language-servers = ["yaml-language-server"];
          formatter = {
            command = "${pkgs.yamlfmt}/bin/yamlfmt";
            args = ["-"];
          };
        }
        {
          name = "cpp";
          auto-format = true;
          language-servers = ["clangd"];
        }
        {
          name = "bash";
          auto-format = true;
          language-servers = ["bash-language-server"];
        }
        {
          name = "cmake";
          auto-format = true;
          language-servers = ["cmake-langugage-server"];
          formatter = {command = "${pkgs.cmake-format}/bin/cmake-format";};
        }
        {
          name = "toml";
          auto-format = true;
          language-servers = ["taplo"];
        }
      ];
    };

    settings = {
      editor = {
        mouse = false;
        auto-format = true;
        auto-save = true;
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
          y = "yank_main_selection_to_clipboard";
          p = "paste_clipboard_before";
        };
      };
    };
  };

  stylix.targets.helix = {
    enable = true;
  };
}
