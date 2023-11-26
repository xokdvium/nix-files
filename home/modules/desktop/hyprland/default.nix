{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.stylix;
  colors = config.lib.stylix.colors;
in {
  imports = [
    ../.
    ./wofi.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      bind = let
        wofi = "${config.programs.wofi.package}/bin/wofi";
        terminal = "${pkgs.kitty}/bin/kitty";
      in [
        "SHIFT,Return,exec,${terminal}"
        "SUPER,d,exec,${wofi} -S run"
      ];

      exec = [
        "${pkgs.swaybg}/bin/swaybg -i ${cfg.image} --mode fill"
      ];

      general = {
        "col.active_border" = lib.mkForce "rgb(${colors.base0C})";
        "col.inactive_border" = lib.mkForce "rgb(${colors.base02})";
        "col.nogroup_border" = lib.mkForce "rgb(${colors.base09})";
        "col.nogroup_border_active" = lib.mkForce "rgb(${colors.base0D})";
      };

      decoration = {
        "col.shadow" = lib.mkForce "rgb(${colors.base01})";
      };
    };
  };
}
