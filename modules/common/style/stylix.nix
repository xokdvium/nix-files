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

  cfg = config.xokdvium.common.style;
in {
  options.xokdvium.common.style = {
    stylix.enable = lib.mkOption {
      description = "Enable fonts styling";
      default = cfg.enable;
      type = lib.types.bool;
    };
  };

  config.stylix = lib.mkIf cfg.stylix.enable {
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

    autoEnable = lib.mkDefault true;
    polarity = lib.mkDefault "dark";

    cursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "Catppuccin-Mocha-Dark-Cursors";
    };

    opacity = let
      alpha = 0.90;
    in {
      terminal = alpha;
      popups = alpha;
      desktop = alpha;
      applications = alpha;
    };
  };
}
