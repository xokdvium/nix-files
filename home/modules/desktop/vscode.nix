{
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;

    extensions = with pkgs.vscode-extensions; [
      llvm-vs-code-extensions.vscode-clangd
      ms-toolsai.jupyter
      xaver.clang-format
      editorconfig.editorconfig
      ms-python.python
    ];
  };
}
