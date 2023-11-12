{
  pkgs,
  config,
  lib,
  ...
}: let
  mkStylixFont = profile:
    lib.mkDefault {
      inherit (profile) package;
      name = profile.family;
    };
in {
  fontProfiles = {
    enable = true;

    monospace = {
      family = "FiraCode Nerd Font";
      package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
    };

    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };

    emoji = {
      family = "Noto Color Emoji";
      package = pkgs.noto-fonts-emoji;
    };
  };

  stylix = {
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Gingeh/wallpapers/main/landscapes/shaded_landscape.png";
      sha256 = "sha256-EZmkN1HxI00/uS7PYU+/NN4sBzNNP901WJEET1G92to=";
    };

    fonts = with config.fontProfiles; {
      serif = mkStylixFont regular;
      sansSerif = mkStylixFont regular;
      monospace = mkStylixFont monospace;
      emoji = mkStylixFont emoji;

      sizes = let
        fontSize = 11;
      in {
        terminal = lib.mkDefault fontSize;
        desktop = lib.mkDefault fontSize;
        popups = lib.mkDefault fontSize;
        applications = lib.mkDefault fontSize;
      };
    };

    autoEnable = lib.mkDefault false;
    polarity = lib.mkDefault "dark";

    base16Scheme =
      lib.mkDefault
      "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

    cursor.package = pkgs.catppuccin-cursors.frappeDark;
    cursor.name = "Catppuccin-Frappe-Dark-Cursors";
  };

  stylix.opacity = let
    alpha = 0.95;
  in {
    terminal = alpha;
    popups = alpha;
    desktop = alpha;
    applications = alpha;
  };
}
