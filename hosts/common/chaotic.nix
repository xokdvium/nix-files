{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.chaotic.nixosModules.default
  ];

  boot = let
    kernel =
      pkgs.linuxPackages_cachyos;
  in {
    kernelPackages = kernel;
    zfs.enableUnstable = true;
  };
}
