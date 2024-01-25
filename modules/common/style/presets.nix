{
  pkgs,
  lib,
  config,
  ...
}: let
  namedPresets = {
    isotope = {
      base16 = "${pkgs.base16-schemes}/share/themes/isotope.yaml";
      image = pkgs.fetchurl {
        url = "https://images.hdqwalls.com/wallpapers/heights-are-not-scary-5k-7s.jpg";
        sha256 = "sha256-rgJkrd7S/uWugPyBVTicbn6HtC8ru5HtEHP426CRSCE=";
      };
    };

    catppuccin-mocha = {
      base16 = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/kx/wallhaven-kxre6q.png";
        sha256 = "sha256-vpE+21/RQIKlIg/xWLZCt1C7yPDKCSmDQoQeJGCKiQ8=";
      };
    };
  };
in {
  options.xokdvium.common.style = {
    preset = lib.mkOption {
      description = "Which preset to use for the theme";
      type = lib.types.either (lib.types.attrs) (lib.types.str);
      default = namedPresets.isotope;
    };
  };

  config = let
    cfg = config.xokdvium.common.style;
    preset =
      if builtins.isAttrs cfg.preset
      then cfg.preset
      else namedPresets.${cfg.preset};
  in {
    stylix = {
      base16Scheme = preset.base16;
      image = preset.image;
    };
  };
}
