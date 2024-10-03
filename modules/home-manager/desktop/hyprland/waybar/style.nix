{
  config,
  lib,
  ...
}:

let
  fonts = config.stylix.fonts;
  colors = config.lib.stylix.colors.withHashtag;
  hyprlandSettings = config.wayland.windowManager.hyprland.settings;
  borderSize = hyprlandSettings.general.border_size;
in

{
  programs.waybar = {
    style = lib.mkForce (
      with colors;
      ''
        @define-color base00 ${base00};
        @define-color base01 ${base01};
        @define-color base02 ${base02};
        @define-color base03 ${base03};
        @define-color base04 ${base04};
        @define-color base05 ${base05};
        @define-color base06 ${base06};
        @define-color base07 ${base07};
        @define-color base08 ${base08};
        @define-color base09 ${base09};
        @define-color base0A ${base0A};
        @define-color base0B ${base0B};
        @define-color base0C ${base0C};
        @define-color base0D ${base0D};
        @define-color base0E ${base0E};
        @define-color base0F ${base0F};

        * {
          font-family: "${fonts.monospace.name}";
          font-size: ${builtins.toString fonts.sizes.desktop}pt;
        }

        window#waybar, 
        tooltip {
          background: alpha(@base00, ${toString (config.stylix.opacity.desktop / 2.0)});
          color: @base05;
          border: ${toString borderSize}px solid @base01;
          border-radius: ${toString hyprlandSettings.decoration.rounding}px;
        }

        #workspaces button {
          background: alpha(@base00, ${toString (config.stylix.opacity.desktop)});
          color: @base05;
          font-size: 13pt;
          margin-right: 10px;
          border: ${toString borderSize}px solid @base03;
          border-radius: ${toString hyprlandSettings.decoration.rounding}px;
        }

      ''
      + (builtins.readFile ./style.css)
    );
  };
}
