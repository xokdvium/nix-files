{inputs, ...}: (
  final: prev: {
    helix = inputs.helix.packages.${final.system}.helix;
  }
)
