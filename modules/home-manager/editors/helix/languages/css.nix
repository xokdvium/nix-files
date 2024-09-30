{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.vscode-css-language-server = {
      command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
      args = [ "--stdio" ];
    };

    language = [
      {
        name = "css";
        language-servers = [
          "vscode-css-language-server"
          "typos-lsp"
        ];
      }
    ];
  };
}
