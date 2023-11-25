{
  pkgs,
  lib,
  config,
  ...
}: {
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
    };
  };
}
