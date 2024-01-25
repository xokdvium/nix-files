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
  options.xokdvium.home.crypto = {
    yubikey.enable = mkHomeCategoryModuleEnableOption config {
      name = "utils";
      category = "crypto";
    };
  };

  config = let
    cfg = config.xokdvium.home.crypto.yubikey;
  in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        yubikey-manager
        yubikey-personalization
        yubico-piv-tool
        yubioath-flutter
        yk-scripts
      ];
    };
}
