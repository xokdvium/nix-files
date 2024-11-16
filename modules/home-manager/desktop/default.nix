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
    ./chromium.nix
    ./deluge.nix
    ./discord.nix
    ./factorio.nix
    ./ferdium.nix
    ./firefox
    ./freecad.nix
    ./gaming.nix
    ./gnome
    ./gtkwave.nix
    ./hiddify-next.nix
    ./icon.nix
    ./libreoffice.nix
    ./matrix-clients.nix
    ./nekoray.nix
    ./obsidian.nix
    ./okular.nix
    ./plasma
    ./prusa-slicer.nix
    ./style.nix
    ./super-slicer
    ./telegram.nix
    ./wezterm.nix
    ./wireshark.nix
    ./zathura.nix
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
