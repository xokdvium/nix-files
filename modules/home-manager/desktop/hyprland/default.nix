{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.stylix;
  colors = config.lib.stylix.colors;
in
{
  imports = [
    ./wofi.nix
    ./binds.nix
    ./waybar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      env = [
        "NIXOS_OZONE_WL,1"
        "MOZ_ENABLE_WAYLAND,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];

      bind =
        let
          wofi = "${config.programs.wofi.package}/bin/wofi";
          firefox = "${config.programs.firefox.package}/bin/firefox";
          terminal = "${config.programs.alacritty.package}/bin/alacritty";
        in
        [
          "SUPER,Return,exec,${terminal}"
          "SUPER,d,exec,${wofi} --show drun"
          "SUPER,D,exec,${wofi} --show run"
          "SUPER,b,exec,${firefox}"
          "SUPER,q,killactive"
          "SUPER,v,togglefloating"
        ];

      exec = [ "${pkgs.swaybg}/bin/swaybg -i ${cfg.image} --mode fill" ];

      general = {
        "col.active_border" = lib.mkForce "rgb(${colors.base0C})";
        "col.inactive_border" = lib.mkForce "rgb(${colors.base02})";
        "col.nogroup_border" = lib.mkForce "rgb(${colors.base09})";
        "col.nogroup_border_active" = lib.mkForce "rgb(${colors.base0D})";
        border_size = 2;
      };

      decoration =
        let
          opacity = config.stylix.opacity.applications;
        in
        {
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
