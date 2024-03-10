{
  outputs,
  config,
  lib,
  ...
}: let
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
    ./matrix-clients.nix
    ./ferdium.nix
    ./wezterm.nix
    ./gnome
  ];

  config.xokdvium = let
    cfg = config.xokdvium.home.desktop;
  in
    lib.mkIf cfg.enable {
      home = {
        headless.enable = true;
        crypto.enable = true;
        editors.enable = true;
      };

      common = {
        style.enable = true;
      };
    };

  options.xokdvium.home.desktop = {
    enable = mkHomeCategoryEnableOption "desktop";
  };
}
