{
  pkgs,
  lib,
  config,
  inputs,
  extraConfig,
  outputs,
  ...
}:
let
  inherit (extraConfig.host) system;
  inherit (outputs.lib) mkHomeCategoryModuleEnableOption;
in
{
  options.xokdvium.home.desktop = {
    firefox = {
      enable = mkHomeCategoryModuleEnableOption config {
        name = "firefox";
        category = "desktop";
      };

      staticBookmarks = lib.mkEnableOption "staticBookmarks";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.firefox;
    in
    lib.mkIf cfg.enable {
      programs.firefox = {
        enable = true;

        # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          DisablePocket = true;
          DisableFirefoxAccounts = true;
          DisableAccounts = true;
          DisableFirefoxScreenshots = true;
        };

        profiles.${config.home.username} = {
          extensions =
            let
              addons = inputs.firefox-addons.packages.${system};
            in
            with addons;
            [
              ublock-origin
              bitwarden
              videospeed
              simplelogin
              linkding-extension
              tridactyl
            ];

          bookmarks = lib.mkIf cfg.staticBookmarks [
            {
              name = "tools";
              toolbar = true;
              bookmarks = [
                {
                  name = "linkding";
                  url = "https://linkding.aeronas.ru/";
                }
              ];
            }
          ];

          settings = {
            "signon.rememberSignons" = false;
            "media.peerconnection.enabled" = false;
          };

          search = {
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "Bing".metaData.hidden = true;
              "Google".metaData.alias = "@g";

              "NixOS Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };

              "Home Manager Options" = {
                urls = [
                  {
                    template = "https://mipmip.github.io/home-manager-option-search";
                    params = [
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@hmo" ];
              };
            };
          };
        };
      };

      xdg = {
        enable = true;
        mimeApps = {
          enable = true;
          defaultApplications = {
            "default-web-browser" = "firefox.desktop";
            "text/html" = "firefox.desktop";
            "text/xml" = "firefox.desktop";
            "x-scheme-handler/http" = "firefox.desktop";
            "x-scheme-handler/https" = "firefox.desktop";
          };
        };
      };

      xokdvium.home.persistence = {
        persist.dirs = [ ".mozilla" ];
      };
    };
}
