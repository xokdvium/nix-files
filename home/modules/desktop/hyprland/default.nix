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
    ./binds.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      bind = let
        wofi = "${config.programs.wofi.package}/bin/wofi";
        firefox = "${config.programs.firefox.package}/bin/firefox";
        terminal = "${config.programs.alacritty.package}/bin/alacritty";
      in [
        "SUPER,Return,exec,${terminal}"
        "SUPER,d,exec,${wofi} -S run"
        "SUPER,b,exec,${firefox}"
        "SUPER,q,killactive"
        "SUPER,v,togglefloating"
      ];

      exec = [
        "${pkgs.swaybg}/bin/swaybg -i ${cfg.image} --mode fill"
      ];

      general = {
        "col.active_border" = lib.mkForce "rgb(${colors.base0C})";
        "col.inactive_border" = lib.mkForce "rgb(${colors.base02})";
        "col.nogroup_border" = lib.mkForce "rgb(${colors.base09})";
        "col.nogroup_border_active" = lib.mkForce "rgb(${colors.base0D})";
        border_size = 2;
      };

      decoration = let
        opacity = 0.95;
      in {
        blur = {
          enabled = true;
        };

        rounding = 12;
        active_opacity = opacity;
        inactive_opacity = opacity;
        "col.shadow" = lib.mkForce "rgb(${colors.base01})";
      };

      input = {
        touchpad = {
          natural_scroll = true;
        };
      };

      animations = {
        enabled = true;
      };

      monitor = ",highres,auto,1";
    };
  };
}
