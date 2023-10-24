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
      url = "https://w.wallhaven.cc/full/gp/wallhaven-gpd6v7.jpg";
      sha256 = "sha256-vpIwHQo63rncbA2n9/pEpBtAVBpOBK5KvVyCqmB/vlw=";
    };

    fonts = with config.fontProfiles; {
      serif = mkStylixFont regular;
      sansSerif = mkStylixFont regular;
      monospace = mkStylixFont monospace;
      emoji = mkStylixFont emoji;

      sizes = let
        fontSize = 10;
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
      "${pkgs.base16-schemes}/share/themes/twilight.yaml";
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
