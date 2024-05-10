{
  outputs,
  config,
  lib,
  ...
}:
let
  inherit (outputs.lib) mkHomeCategoryEnableOption;
in
{
  imports = [
    ./alacritty.nix
    ./bitwarden.nix
    ./deluge.nix
    ./discord.nix
    ./factorio.nix
    ./ferdium.nix
    ./firefox.nix
    ./freecad.nix
    ./gaming.nix
    ./gnome
    ./plasma
    ./libreoffice.nix
    ./matrix-clients.nix
    ./obsidian.nix
    ./okular.nix
    ./prusa-slicer.nix
    ./style.nix
    ./telegram.nix
    ./wezterm.nix
    ./wireshark.nix
    ./zathura.nix
    ./gtkwave.nix
    ./chromium.nix
  ];

  config.xokdvium =
    let
      cfg = config.xokdvium.home.desktop;
    in
    lib.mkIf cfg.enable {
      home = {
        crypto.enable = true;
        editors.enable = true;
        headless.enable = true;
      };

      common = {
        style.enable = true;
      };
    };

  options.xokdvium.home.desktop = {
    enable = mkHomeCategoryEnableOption "desktop";
  };
}
