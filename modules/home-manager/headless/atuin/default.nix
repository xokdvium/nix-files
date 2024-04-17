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
  options.xokdvium.home.headless = {
    atuin = {
      enable = mkHomeCategoryModuleEnableOption config {
        name = "atuin";
        category = "headless";
      };

      enableZfsPatch = lib.mkOption {
        description = "Enable Mic92 make-atuin-on-zfs-fast-again patch which disables db sync";
        type = lib.types.bool;
        default = false;
      };

      noShellHistory = lib.mkEnableOption "noShellHistory";
      autoSync = lib.mkEnableOption "autoSync";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.atuin;
    in
    lib.mkIf cfg.enable {
      programs = {
        atuin = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;

          package = pkgs.atuin.overrideAttrs (oldAttrs: rec {
            version = "18.2.0";

            src = pkgs.fetchFromGitHub {
              owner = "atuinsh";
              repo = "atuin";
              rev = "v${version}";
              hash = "sha256-TTQ2XLqng7TMLnRsLDb/50yyHYuMSPZJ4H+7CEFWQQ0=";
            };

            # https://github.com/Mic92/dotfiles/blob/main/home-manager/pkgs/atuin/default.nix
            # Very cursed patch, but this should help make zfs desktop performance better.
            # But on the other hand this may result in database corruptions :(
            patches = lib.optionals cfg.enableZfsPatch [ ./0001-make-atuin-on-zfs-fast-again.patch ];

            cargoDeps = oldAttrs.cargoDeps.overrideAttrs (
              pkgs.lib.const {
                name = "atuin-${version}-vendor.tar.gz";
                inherit src;
                outputHash = "sha256-KMH19Op7uyb3Z/cjT6bdmO+JEp1o2n6rWRNYmn1+0hE=";
              }
            );

            checkFlags = [
              "--skip=registration"
              "--skip=sync"
              "--skip=change_password"
              "--skip=multi_user_test"
              "--skip=build_aliases"
            ];
          });

          settings = {
            auto_sync = cfg.autoSync;
            sync_frequency = "5m";
            filter_mode = "host";
            filter_mode_shell_up_key_binding = "session";
          };
        };

        zsh.history.path = lib.mkIf cfg.noShellHistory "/dev/null";
        bash.historyFile = lib.mkIf cfg.noShellHistory "/dev/null";
      };

      home.persistence."/persistent/home/${config.home.username}" =
        lib.mkIf config.xokdvium.home.persistence.enable
          { directories = [ ".local/share/atuin" ]; };
    };
}
