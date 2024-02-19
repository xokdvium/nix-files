{pkgs, ...}: {
  boot = let
    kernel =
      pkgs.linuxPackages_cachyos;
  in {
    kernelPackages = kernel;
    zfs.enableUnstable = true;
  };
}
