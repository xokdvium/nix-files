{pkgs, ...}: {
  programs = {
    bat = {
      enable = true;

      extraPackages = with pkgs.bat-extras; [
        prettybat
        batwatch
        batpipe
        batman
        batgrep
        batdiff
      ];
    };

    zsh.shellAliases = {
      # There's really no reason to use default man when there's batman
      bman = "batman";
    };
  };

  stylix.targets = {
    bat.enable = true;
  };
}
