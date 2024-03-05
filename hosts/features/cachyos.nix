{pkgs, ...}: {
  boot = let
    kernel =
      pkgs.linuxPackages_cachyos;
  in {
    kernelPackages = kernel;
    zfs.package = pkgs.zfs_unstable;
  };
}
