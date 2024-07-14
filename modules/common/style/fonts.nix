{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.xokdvium.common.style;
in
{
  options.xokdvium.common.style = {
    fonts.enable = lib.mkOption {
      description = "Enable fonts styling";
      default = cfg.enable;
      type = lib.types.bool;
    };
  };

  config.fontProfiles = lib.mkIf cfg.fonts.enable {
    enable = true;

    monospace = {
      family = "JetBrainsMono Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
    };

    regular = {
      family = "Noto Sans";
      package = pkgs.noto-fonts;
    };

    emoji = {
      family = "Noto Color Emoji";
      package = pkgs.noto-fonts-emoji;
    };
  };
}
