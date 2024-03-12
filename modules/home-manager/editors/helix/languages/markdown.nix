{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.marksman = {
      command = "${pkgs.marksman}/bin/marksman";
      args = [ "server" ];
    };

    language = [
      {
        name = "markdown";
        formatter = {
          command = "${pkgs.mdformat}/bin/mdformat";
          args = [ "-" ];
        };
        auto-format = true;
        language-servers = [
          "marksman"
          "typos-lsp"
        ];
      }
    ];
  };
}
