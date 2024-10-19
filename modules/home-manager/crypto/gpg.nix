{
  pkgs,
  outputs,
  config,
  lib,
  ...
}:
let
  inherit (outputs.lib) mkHomeCategoryModuleEnableOption;
in
{
  options.xokdvium.home.crypto = {
    gpg.enable = mkHomeCategoryModuleEnableOption config {
      name = "gpg";
      category = "crypto";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.crypto.gpg;
    in
    lib.mkIf cfg.enable {

      programs.gpg = {
        enable = true;
        publicKeys = [
          {
            source = ../../../secrets/keys/pgp.asc;
            trust = 5;
          }
        ];

        scdaemonSettings = {
          reader-port = "Yubico Yubi";
        };
      };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableScDaemon = true;
        pinentryPackage = pkgs.pinentry-curses;
      };

      home.packages = with pkgs; [ gpg-scripts ];
    };
}
