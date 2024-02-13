{
  outputs,
  lib,
  pkgs,
  config,
  ...
}: let
  inherit
    (outputs.lib)
    mkHomeCategoryModuleEnableOption
    ;
  cfg = config.xokdvium.home.desktop;

  colorsFile = config.lib.stylix.colors {
    template = ./config/colors.mustache;
    extension = ".scss";
  };

  themeFile = pkgs.substituteAll (let
    inherit (config.stylix) fonts;
    inherit (config.wayland.windowManager.hyprland) settings;
  in {
    src = ./config/misc.scss;
    fontfamily = fonts.monospace.name;
    fontsize = fonts.sizes.desktop;
    bordersize = settings.general.border_size;
  });

  ewwTheme = pkgs.stdenv.mkDerivation {
    pname = "eww-colors";
    version = "0.0.1";
    src = lib.cleanSource ./.;
    installPhase = ''
      mkdir -p $out/
      cp ${colorsFile} $out/colors.scss
      cp ${themeFile} $out/misc.scss
    '';
  };

  ewwConfig = pkgs.symlinkJoin {
    name = "eww-config-tree";
    paths = [
      (pkgs.callPackage ./widgets {})
      (pkgs.callPackage ./config {})
      ewwTheme
    ];
  };
in {
  options.xokdvium.home.desktop = {
    eww.enable = mkHomeCategoryModuleEnableOption config {
      name = "eww";
      category = "desktop";
      autoEnable = cfg.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.eww.enable {
    programs.eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ewwConfig;
    };
  };
}
