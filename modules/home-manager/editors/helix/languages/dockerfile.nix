{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server = {
      docker-langserver = {
        command = "${pkgs.dockerfile-language-server-nodejs}/bin/docker-langserver";
        args = [ "--stdio" ];
      };
    };

    language = [
      {
        name = "dockerfile";
        language-servers = [
          "docker-langserver"
          "typos-lsp"
        ];
      }
    ];
  };
}
