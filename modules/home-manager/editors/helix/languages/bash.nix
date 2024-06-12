{ pkgs, ... }:
{
  home.packages = with pkgs; [ shellcheck ];

  programs.helix.languages = {
    language-server.bash-language-server = {
      command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
    };

    language = [
      {
        name = "bash";
        auto-format = true;
        language-servers = [
          "bash-language-server"
          "typos-lsp"
        ];
        formatter = {
          command = "${pkgs.shfmt}/bin/shfmt";
          args = [ "-" ];
        };
      }
    ];
  };
}
