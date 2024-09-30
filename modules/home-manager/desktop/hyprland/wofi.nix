{
  config,
  pkgs,
  lib,
  ...
}:

let
  fonts = config.stylix.fonts;
  colors = config.lib.stylix.colors.withHashtag;
  hyprlandSettings = config.wayland.windowManager.hyprland.settings;
in

{
  # https://todo.sr.ht/~scoopta/wofi/176
  # HACK: This effectively overrides xterm with alacritty. We must make sure
  # that xterm is not installed, otherwise this would cause collisions.
  home.packages = [
    (pkgs.writeShellScriptBin "xterm" ''
      ${lib.getExe config.programs.alacritty.package} "$@"
    '')
  ];

  programs.wofi = {
    enable = true;
    settings = {
      image_size = 48;
      columns = 1;
      allow_images = true;
      insensitive = true;
      run-always_parse_args = true;
      run-cache_file = "/dev/null";
      run-exec_search = true;
      no_actions = true;
      term = "${lib.getExe config.programs.alacritty.package}";
    };

    style =
      let
        defaultPadding = "${toString 10.0}";
        defaultMargin = "${toString 5.0}";
      in
      with colors;
      # https://www.reddit.com/r/hyprland/comments/17k5rxl/comment/kaokn3x/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
      ''
        * {
          font-family: "${fonts.monospace.name}";
          font-size: ${toString fonts.sizes.popups}pt;
        }

        #window {
          background-color: ${base00};
          color: ${base05};
          opacity: ${toString config.stylix.opacity.popups};
          border: ${toString hyprlandSettings.general.border_size}px solid;
          border-radius: ${toString hyprlandSettings.decoration.rounding}px;
          border-color: ${base0C};
        }

        #inner-box {
          background-color: ${base00};
          margin: ${defaultMargin}px;
          padding: ${defaultPadding}px;
        }

        #input {
          background-color: ${base01};
          margin: ${defaultMargin}px;
          padding: ${defaultPadding}px;
          color: ${base04};
          border-color: ${base02};
        }

        #scroll {
          background-color: ${base00};
          margin: ${defaultMargin}px;
          padding: ${defaultPadding}px;
        }

        #entry:nth-child(odd) {
          background-color: ${base00};
        }

        #entry:nth-child(even) {
          background-color: ${base01};
        }

        #entry:selected {
          background-color: ${base02};
        }

        #input:focus {
          border-color: ${base0D};
        }
      '';
  };

  stylix.targets.wofi = {
    enable = false;
  };
}
