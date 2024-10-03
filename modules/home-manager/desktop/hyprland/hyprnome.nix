{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [ hyprnome ];

  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "SUPER,page_up,exec,${lib.getExe pkgs.hyprnome} --previous"
        "SUPER,page_down,exec,${lib.getExe pkgs.hyprnome}"
      ];
    };
  };
}
