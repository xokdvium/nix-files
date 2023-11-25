{inputs, ...}: (
  final: prev: {
    hyprland = inputs.hyprland.packages.${final.system}.hyprland;
  }
)
