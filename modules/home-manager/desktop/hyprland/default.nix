{
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (outputs.lib)
    mkHomeCategoryModuleEnableOption
    ;
  stylixCfg = config.stylix;
  colors = config.lib.stylix.colors;
  cursorCfg = config.stylix.cursor;
in {
  options.xokdvium.home.desktop = {
    hyprland.enable = mkHomeCategoryModuleEnableOption config {
      name = "hyprland";
      category = "desktop";
      autoEnable = false;
    };
  };

  imports = [
    ./fuzzel.nix
    ./binds.nix
    ./dunst.nix
    ./eww
  ];

  config = let
    cfg = config.xokdvium.home.desktop.hyprland;
  in
    lib.mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          env = [
            "NIXOS_OZONE_WL,1"
            "MOZ_ENABLE_WAYLAND,1"
            "XDG_SESSION_TYPE,wayland"
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "XWAYLAND_NO_GLAMOR,1"
            "OBSIDIAN_USE_WAYLAND,1"
            "QT_QPA_PLATFORM,wayland"
          ];

          bind = let
            fuzzel = "${config.programs.fuzzel.package}/bin/fuzzel";
            firefox = "${config.programs.firefox.package}/bin/firefox";
            terminal = "${config.programs.alacritty.package}/bin/alacritty";
          in [
            "SUPER,Return,exec,${terminal}"
            "SUPER,d,exec,${fuzzel}"
            "SUPER,b,exec,${firefox}"
            "SUPER,q,killactive"
            "SUPER,v,togglefloating"
          ];

          exec = lib.mkBefore [
            "hyprctl setcursor ${cursorCfg.name} ${builtins.toString cursorCfg.size}"
            "${pkgs.swaybg}/bin/swaybg -i ${stylixCfg.image} --mode fill"
            "${config.programs.eww.package}/bin/eww daemon"
          ];

          general = {
            "col.active_border" = lib.mkForce "rgb(${colors.base0C}) rgb(${colors.base0E}) 45deg";
            "col.inactive_border" = lib.mkForce "rgb(${colors.base02})";
            "col.nogroup_border" = lib.mkForce "rgb(${colors.base09})";
            "col.nogroup_border_active" = lib.mkForce "rgb(${colors.base0D})";
            border_size = 2;
          };

          decoration = let
            opacity = config.stylix.opacity.applications;
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
            kb_layout = "us,ru";
            kb_options = "grp:alt_shift_toggle";
          };

          animations = {
            enabled = true;
          };

          monitor = ",highrr,auto,1,vrr,1";
        };
      };
    };
}
