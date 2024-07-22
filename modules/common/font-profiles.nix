setPackagesAttr:
{ lib, config, ... }:
let
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

  cfg = config.xokdvium.common.fontProfiles;
  profileNames = [
    "monospace"
    "regular"
    "emoji"
  ];
in
{
  options.xokdvium.common.fontProfiles = {
    enable = lib.mkEnableOption "Whether to enable font profiles";
  } // (lib.genAttrs profileNames mkFontOption);

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      { fonts.fontconfig.enable = true; }
      (setPackagesAttr (
        builtins.map (value: (builtins.getAttr "package" (builtins.getAttr value cfg))) profileNames
      ))
    ]
  );
}
