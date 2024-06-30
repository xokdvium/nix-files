{ pkgs, ... }:
{
  programs.helix.languages = {
    language = [
      {
        name = "groovy";
        language-servers = [ "typos-lsp" ];
        formatter = {
          command = "${pkgs.npm-groovy-lint}/bin/npm-groovy-lint";
          args = [
            "--format"
            "-"
          ];
        };
      }
    ];
  };
}
