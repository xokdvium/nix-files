{
  pkgs,
  lib,
  ...
}: {
  programs = {
    starship = {
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
