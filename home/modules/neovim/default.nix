{pkgs, ...}: {
  # https://github.com/rayandrew/nix-config
  home.packages = with pkgs; [nvchad alejandra ripgrep];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim" = {source = "${pkgs.nvchad}";};
}
