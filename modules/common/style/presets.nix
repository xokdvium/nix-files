{
  pkgs,
  lib,
  config,
  ...
}:
let
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

    eighties-spaceduck = {
      base16 = "${pkgs.base16-schemes}/share/themes/spaceduck.yaml";
      image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/o5/wallhaven-o5p5rl.jpg";
        sha256 = "sha256-l8Ku7OprZKoitZpDQeiFfwXk/guRItxAtINVAbZk+24=";
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
        url = "https://w.wallhaven.cc/full/9d/wallhaven-9dzr8w.png";
        sha256 = "sha256-fgfzyAXnajnHOJ/HD/n+piDwmdTGrwcKzlMyhjVC0bQ=";
      };
    };

    stella = {
      base16 = "${pkgs.base16-schemes}/share/themes/stella.yaml";
      image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/9d/wallhaven-9dzr8w.png";
        sha256 = "sha256-fgfzyAXnajnHOJ/HD/n+piDwmdTGrwcKzlMyhjVC0bQ=";
      };
    };

    synth-midnight-dark = {
      base16 = "${pkgs.base16-schemes}/share/themes/synth-midnight-dark.yaml";
      image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/yx/wallhaven-yxwggg.jpg";
        sha256 = "sha256-LATNG/CDZQPeMM0alJv3ZvM6d1YSnFqPvq0JZISazAs=";
      };
    };

    catppuccin-macchiato = {
      base16 = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/1p/wallhaven-1pm6yv.jpg";
        sha256 = "sha256-lJusIsOUWEtBFEaWJ+0BNxqax37n1mwf0gx2/tklRAk=";
      };
    };
  };
in
{
  options.xokdvium.common.style = {
    preset = lib.mkOption {
      description = "Which preset to use for the theme";
      type = lib.types.either (lib.types.attrs) (lib.types.str);
      default = namedPresets.isotope;
    };
  };

  config =
    let
      cfg = config.xokdvium.common.style;
      preset = if builtins.isAttrs cfg.preset then cfg.preset else namedPresets.${cfg.preset};
    in
    {
      stylix = {
        base16Scheme = preset.base16;
        image = preset.image;
      };
    };
}
