{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.tblgen-lsp-server = {
      command = "${pkgs.llvmPackages_17.mlir}/bin/tblgen-lsp-server";
    };

    language = [
      {
        name = "tablegen";
        language-servers = [
          "tblgen-lsp-server"
          "typos-lsp"
        ];
      }
    ];
  };
}
