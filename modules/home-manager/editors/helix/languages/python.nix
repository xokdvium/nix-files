{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server = {
      pyright = {
        command = "${pkgs.pyright}/bin/pyright-langserver";
        args = [ "--stdio" ];
      };

      ruff = {
        command = "${pkgs.ruff-lsp}/bin/ruff-lsp";
      };

      pylsp = {
        command = "${pkgs.python312Packages.python-lsp-server}/bin/pylsp";
      };

      jedi-language-server = {
        command = "${pkgs.python312Packages.jedi-language-server}/bin/jedi-language-server";
      };
    };

    language = [
      {
        name = "python";
        auto-format = true;
        formatter = {
          command = "${pkgs.black}/bin/black";
          args = [ "-" ];
        };
        language-servers = [
          "pyright"
          "ruff"
          "pylsp"
          "jedi-language-server"
          "typos-lsp"
        ];
      }
    ];
  };
}
