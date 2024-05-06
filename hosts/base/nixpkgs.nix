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
          "steam-original"
          "steam-run"
          "nvidia-x11"
          "nvidia-settings"
          "nvidia-persistenced"
        ];
    };
    overlays = builtins.attrValues outputs.overlays;
  };
}
