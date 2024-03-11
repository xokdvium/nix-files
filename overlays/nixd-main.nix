{inputs, ...}: (
  final: prev: {
    nixd = inputs.nixd.packages.${prev.system}.nixd;
  }
)
