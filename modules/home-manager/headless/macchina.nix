{
  pkgs,
  outputs,
  config,
  lib,
  ...
}:

let
  inherit (outputs.lib) mkHomeCategoryModuleEnableOption;
  settingsFormat = pkgs.formats.toml { };
in

{
  options.xokdvium.home.headless = {
    macchina = {
      enable = mkHomeCategoryModuleEnableOption config {
        name = "macchina";
        category = "headless";
        autoEnable = true;
      };

      package = lib.mkPackageOption pkgs "macchina" { };

      enableZshIntegration = lib.mkEnableOption "Zsh integration" // {
        default = true;
      };

      settings = lib.mkOption {
        type = settingsFormat.type;
        default = { };

        description = ''
          Macchina configuration. See the [example](https://github.com/Macchina-CLI/macchina/blob/main/macchina.toml) for reference.
        '';

        example = {
          long_uptime = true;
          long_shell = false;
          long_kernel = false;
          current_shell = true;
          physical_cores = true;
        };
      };
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.macchina;
      macchinaThemes = "${pkgs.macchina.src}/contrib/themes";
    in
    lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];

      xdg.configFile = {
        "macchina/macchina.toml".source = settingsFormat.generate "macchina.toml" cfg.settings;
        "macchina/themes".source = macchinaThemes;
      };

      programs = {
        zsh.initExtra = lib.mkIf cfg.enableZshIntegration ''
          ${lib.getExe cfg.package}
        '';
      };

      xokdvium.home.headless.macchina.settings = {
        long_kernel = lib.mkDefault true;
        long_uptime = lib.mkDefault true;
        long_shell = lib.mkDefault false;
        current_shell = lib.mkDefault true;
        physical_cores = lib.mkDefault true;
        theme = lib.mkDefault "Lithium";
      };
    };
}
