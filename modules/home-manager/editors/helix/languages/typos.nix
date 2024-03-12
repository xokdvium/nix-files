{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.typos-lsp = {
      command = "${pkgs.typos-lsp}/bin/typos-lsp";
    };
  };
}
