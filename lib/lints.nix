{inputs, ...}: let
  inherit (inputs) lint-nix;
in
  pkgs: src:
    lint-nix.lib.lint-nix rec {
      inherit pkgs src;

      linters = {
        typos = {
          ext = "";
          cmd = "${pkgs.typos}/bin/typos $filename";
        };
      };

      formatters = {
        yamlfmt = {
          ext = [".yaml" ".yml" ".clang-format" ".clang-tidy"];
          cmd = "${pkgs.yamlfmt}/bin/yamlfmt $filename";
        };

        alejandra = {
          ext = ".nix";
          cmd = "${pkgs.alejandra}/bin/alejandra --quiet";
          stdin = true;
        };
      };
    }
