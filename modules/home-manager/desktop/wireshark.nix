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
  options.xokdvium.home.desktop = {
    wireshark.enable = mkHomeCategoryModuleEnableOption config {
      name = "wireshark";
      category = "desktop";
    };
  };

  config = let
    cfg = config.xokdvium.home.desktop.wireshark;
  in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        wireshark
        termshark
      ];
    };
}
