{ config, ... }:

let
  hyprlandSettings = config.wayland.windowManager.hyprland.settings;
in

{
  imports = [
    ./style.nix
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [
      {
        height = 40;
        layer = "top";
        margin-left = hyprlandSettings.general.gaps_out;
        margin-right = hyprlandSettings.general.gaps_out;
        margin-top = hyprlandSettings.general.gaps_out;
        position = "top";
        tray = {
          spacing = 20;
        };

        modules-center = [ "hyprland/window" ];
        modules-left = [ "hyprland/workspaces" ];

        modules-right = [
          "pulseaudio"
          "network"
          "clock"
          "tray"
        ];

        clock = {
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };

        network = {
          interval = 1;
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
          format-linked = "{ifname} (No IP) ";
          format-wifi = "{essid} ({signalStrength}%) ";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            car = "";
            default = [
              ""
              ""
              ""
            ];
            handsfree = "";
            headphones = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
        };
      }
    ];
  };
}
