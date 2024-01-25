{outputs, ...}: let
  inherit (outputs.lib) mkHomeCategoryEnableOption;
in {
  imports = [
    ./helix
    ./vscode
  ];

  options.xokdvium.home.editors = {
    enable = mkHomeCategoryEnableOption "editors";
  };
}
