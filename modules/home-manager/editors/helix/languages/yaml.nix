{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.yaml-language-server = {
      command = "${pkgs.nodePackages_latest.yaml-language-server}/bin/yaml-language-server";
      args = [ "--stdio" ];
    };

    language = [
      {
        name = "yaml";
        file-types = [
          "yml"
          "yaml"
          ".clang-format"
          ".clang-tidy"
        ];
        auto-format = true;
        language-servers = [
          "yaml-language-server"
          "typos-lsp"
        ];
        formatter = {
          command = "${pkgs.yamlfmt}/bin/yamlfmt";
          args = [ "-" ];
        };
      }
    ];
  };
}
