{pkgs, ...}: {
  # https://github.com/rayandrew/nix-config
  home.packages = with pkgs; [
    # My custom config based on NvChad
    nvchad

    # Tools needed to make this stuff work
    ripgrep
    nodejs_20
    unzip

    # I could install all of these LSP packages with Mason but it seems way better to me
    # to do this on the home manager level and not at nvim runtime.

    # Language servers

    # Nix stuff
    statix
    deadnix
    nil
    alejandra

    # Lua
    lua-language-server
    stylua

    # Shell
    nodePackages.bash-language-server
    beautysh
    shellcheck

    # Python
    (pkgs.python3.withPackages
      (pyPkgs:
        with pyPkgs; [
          jedi-language-server
          autopep8
        ]))

    # C/C++ tools
    clang-tools_16
    cmake-language-server
    cmake-format

    # Markup
    taplo
    yaml-language-server
    yamlfix
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim" = {source = "${pkgs.nvchad}";};
}
