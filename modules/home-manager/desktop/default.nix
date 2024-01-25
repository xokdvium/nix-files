{outputs, ...}: let
  inherit (outputs.lib) mkHomeCategoryEnableOption;
in {
  imports = [
    ./alacritty.nix
    ./bitwarden.nix
    ./discord.nix
    ./firefox.nix
    ./style.nix
    ./telegram.nix
    ./zathura.nix
    ./wireshark.nix
    ./deluge.nix
    ./prusa-slicer.nix
    ./freecad.nix
    ./obsidian.nix
    ./okular.nix
    ./gnome
  ];

  config.xokdvium.home = {
    headless.enable = true;
    crypto.enable = true;
    editors.enable = true;
  };

  options.xokdvium.home.desktop = {
    enable = mkHomeCategoryEnableOption "desktop";
  };
}
