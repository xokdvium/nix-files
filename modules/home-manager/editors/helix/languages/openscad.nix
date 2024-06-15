{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.openscad-lsp = {
      command = "${pkgs.openscad-lsp}/bin/openscad-lsp";
      args = [ "--stdio" ];
    };

    language = [
      {
        name = "openscad";
        language-servers = [
          "openscad-lsp"
          "typos-lsp"
        ];
      }
    ];
  };
}
