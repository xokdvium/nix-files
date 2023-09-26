{ pkgs, ... }: {
  # https://github.com/rayandrew/nix-config

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim" = { source = "${pkgs.nvchad}"; };

  home.packages = [ pkgs.nvchad ];
}
