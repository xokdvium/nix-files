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

    catppuccin-frappe = {
      base16 = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
      image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/kx/wallhaven-kxre6q.png";
        sha256 = "sha256-vpE+21/RQIKlIg/xWLZCt1C7yPDKCSmDQoQeJGCKiQ8=";
      };
    };

    atelier-lakeside = {
      base16 = "${pkgs.base16-schemes}/share/themes/atelier-lakeside.yaml";
      image = pkgs.fetchurl {
        url = "https://r4.wallpaperflare.com/wallpaper/410/867/750/vector-forest-sunset-forest-sunset-forest-wallpaper-b3abc35d0d699b056fa6b247589b18a8.jpg";
        sha256 = "sha256-8ytn00rZUiJxgtjXqTxtR7qusokxjY68u+UiWuwD8Bs=";
      };
    };

    spaceduck = {
      base16 = "${pkgs.base16-schemes}/share/themes/spaceduck.yaml";
      image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/6d/wallhaven-6d5k6x.jpg";
        sha256 = "sha256-+xl4H3UiVmMRNvMhIlaLdVTYYqnSyCTSX2UOTGsDQ8c=";
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
