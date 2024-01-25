{
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
    starship.enable = mkHomeCategoryModuleEnableOption config {
      name = "starship";
      category = "headless";
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.starship;
  in
    lib.mkIf cfg.enable {
      programs.starship = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;

        settings = {
          add_newline = false;

          git_status = {
            conflicted = "🏳";
            ahead = "🏎💨";
            behind = "😰";
            diverged = "😵";
            up_to_date = "✓";
            untracked = "🤷";
            stashed = "📦";
            modified = "📝";
            staged = "[++\($count\)](green)";
            renamed = "👅";
            deleted = "🗑 ";
          };
        };
      };
    };
}
