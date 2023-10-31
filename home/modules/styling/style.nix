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
      url = "https://w.wallhaven.cc/full/ex/wallhaven-ex2dol.jpg";
      sha256 = "sha256-rNOzyjLx3WXZbMicLkvVcVZD9/MSsvYUPC6WQ7BsKIs=";
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
      "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";
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
