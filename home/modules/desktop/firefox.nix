{
  pkgs,
  lib,
  config,
  inputs,
  extraConfig,
  ...
}: let
  inherit (extraConfig.host) system;
in {
  programs.firefox = {
    enable = true;
    profiles.${config.home.username} = {
      bookmarks = {};

      extensions = let
        addons = inputs.firefox-addons.packages.${system};
      in
        with addons; [
          ublock-origin
          bitwarden
          gopass-bridge
          videospeed
          simplelogin
        ];

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
            definedAliases = ["@np"];
          };

          "Bing".metaData.hidden = true;
          "Google".metaData.alias = "@g";
        };
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };

  home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.extraOptions.persistence.enable {
    directories = [".mozilla"];
  };
}
