{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.metals = {
      command = "${pkgs.metals}/bin/metals";
      config = {
        "isHttpEnabled" = true;
      };
    };

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
        language-servers = [
          "metals"
          "typos-lsp"
        ];
      }
    ];
  };
}
