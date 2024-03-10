{
  pkgs,
  outputs,
  config,
  lib,
  ...
}: let
  inherit
    (outputs.lib)
    mkHomeCategoryModuleEnableOption
    ;
in {
  options.xokdvium.home.editors = {
    vscode.enable = mkHomeCategoryModuleEnableOption config {
      name = "vscode";
      category = "editors";
      autoEnable = false;
    };
  };

  config = let
    cfg = config.xokdvium.home.editors.vscode;
  in
    lib.mkIf cfg.enable {
      programs.vscode = {
        enable = true;
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        package = pkgs.vscodium;

        extensions = with pkgs.vscode-extensions;
          [
            llvm-vs-code-extensions.vscode-clangd
            ms-toolsai.jupyter
            xaver.clang-format
            editorconfig.editorconfig
            ms-python.python
            ms-pyright.pyright
            ms-python.black-formatter
            mkhl.direnv
            ms-vscode.cmake-tools
            waderyan.gitblame
            ms-azuretools.vscode-docker
            mhutchie.git-graph
            gitlab.gitlab-workflow
            github.vscode-pull-request-github
            redhat.vscode-yaml
            catppuccin.catppuccin-vsc
            tomoki1207.pdf
          ]
          ++ (with pkgs.vscode-marketplace; [
            jasew.vscode-helix-emulation
          ]);
      };
    };
}
