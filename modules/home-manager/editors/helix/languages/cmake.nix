{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.cmake-language-server = {
      command = "${pkgs.cmake-language-server}/bin/cmake-language-server";
    };

    language-server.neocmakelsp = {
      command = "${pkgs.neocmakelsp}/bin/neocmakelsp";
      args = [ "--stdio" ];
    };

    language = [
      {
        name = "cmake";
        auto-format = true;
        language-servers = [
          "neocmakelsp"
          "cmake-language-server"
          "typos-lsp"
        ];
        formatter = {
          command = "${pkgs.cmake-format}/bin/cmake-format";
          args = [ "-" ];
        };
      }
    ];
  };
}
