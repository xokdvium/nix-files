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
        package = pkgs.gnupg.override {
          # TODO: Remove when PR 308884 is available
          pcsclite = pkgs.pcsclite.overrideAttrs (old: {
            postPatch =
              old.postPatch
              + (lib.optionalString
                (!(lib.strings.hasInfix ''--replace-fail "libpcsclite_real.so.1"'' old.postPatch))
                ''
                  substituteInPlace src/libredirect.c src/spy/libpcscspy.c \
                    --replace-fail "libpcsclite_real.so.1" "$lib/lib/libpcsclite_real.so.1"
                ''
              );
          });
        };

        enable = true;
        publicKeys = [
          {
            source = ../../../secrets/keys/pgp.asc;
            trust = 5;
          }
        ];

        scdaemonSettings = {
          reader-port = "Yubico Yubi";
          disable-ccid = true;
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
