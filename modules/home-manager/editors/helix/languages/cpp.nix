{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.clangd = {
      command = "${pkgs.clang-tools_18}/bin/clangd";
      args = [ "--header-insertion=never" ];
    };

    language = [
      {
        name = "cpp";
        auto-format = true;
        language-servers = [
          "clangd"
          "typos-lsp"
        ];
      }
    ];
  };
}
