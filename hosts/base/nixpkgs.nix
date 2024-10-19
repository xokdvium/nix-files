{ outputs, lib, ... }:

{
  nixpkgs = {
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "obsidian"
          "factorio-alpha"
          "discord"
          "zerotierone"
          "steam"
          "steam-unwrapped"
          "steam-original"
          "steam-run"
          "nvidia-x11"
          "nvidia-settings"
          "nvidia-persistenced"
          "libXNVCtrl"
        ];
    };
    overlays = builtins.attrValues outputs.overlays;
  };
}
