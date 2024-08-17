{ pkgs, ... }:

{
  programs.helix.languages = {
    language = [
      {
        name = "scheme";
        auto-format = true;
        language-servers = [ "typos-lsp" ];
        formatter = {
          command = "${pkgs.schemat}/bin/schemat";
        };
      }
    ];
  };
}
