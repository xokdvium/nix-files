{
  lib,
  config,
  ...
}: let
  mkFontOption = kind: {
    family = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Family name for ${kind} font profile";
      example = "Fira Code";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = null;
      description = "Package for ${kind} font profile";
      example = "pkgs.fira-code";
    };
  };

  cfg = config.fontProfiles;
  profileNames = ["monospace" "regular" "emoji"];
in {
  options.fontProfiles =
    {
      enable = lib.mkEnableOption "Whether to enable font profiles";
    }
    // (lib.genAttrs profileNames mkFontOption);

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages =
      builtins.map
      (value: (builtins.getAttr "package" (builtins.getAttr value cfg)))
      profileNames;
  };
}
