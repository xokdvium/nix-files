{
  pkgs,
  outputs,
  config,
  lib,
  ...
}: let
  inherit
    (outputs.lib)
    mkHomeCategoryModuleEnableOption
    ;
in {
  options.xokdvium.home.headless = {
    zsh.enable = mkHomeCategoryModuleEnableOption config {
      name = "zsh";
      category = "headless";
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.zsh;
  in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [thefuck navi];
      programs = {
        zsh = {
          enable = true;

          enableCompletion = true;
          enableAutosuggestions = true;
          historySubstringSearch.enable = true;
          syntaxHighlighting.enable = true;

          oh-my-zsh = {
            enable = true;
            plugins = ["git" "thefuck"];
          };
        };
      };

      home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.xokdvium.home.persistence.enable {
        files = [".zsh_history"];
      };
    };
}
