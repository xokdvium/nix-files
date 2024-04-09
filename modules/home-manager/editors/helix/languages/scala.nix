{ pkgs, ... }:
{
  programs.helix.languages = {
    language = [
      {
        name = "scala";
        formatter = {
          command = "${pkgs.scalafmt}/bin/scalafmt";
          args = [
            "--stdin"
            "--stdout"
          ];
        };
        auto-format = true;
        language-servers = [ "typos-lsp" ];
      }
    ];
  };
}
