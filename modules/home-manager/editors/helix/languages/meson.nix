{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.mesonlsp = {
      command = "${pkgs.mesonlsp}/bin/mesonlsp";
      args = [ "--lsp" ];
    };

    language = [
      {
        name = "meson";
        auto-format = true;
        language-servers = [
          "mesonlsp"
          "typos-lsp"
        ];
      }
    ];
  };
}
