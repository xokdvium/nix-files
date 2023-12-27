{lib, ...}: {
  nebulinx = import ./machines/nebulinx {inherit lib;};
  generic = import ./machines/generic {inherit lib;};
  vivobook = import ./machines/vivobook {inherit lib;};
  airgapped = import ./machines/airgapped {inherit lib;};
  aarch64-basic = import ./machines/aarch64-basic {inherit lib;};
  borg = import ./machines/borg {inherit lib;};
  julia = import ./machines/julia {inherit lib;};
}
