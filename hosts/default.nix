{lib, ...}: {
  nebulinx = import ./machines/nebulinx {inherit lib;};
  generic = import ./machines/generic {inherit lib;};
  vivobook = import ./machines/vivobook {inherit lib;};
  airgapped = import ./machines/airgapped {inherit lib;};
  julia = import ./machines/julia {inherit lib;};
}
