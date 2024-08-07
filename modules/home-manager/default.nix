{
  # NOTE: Different name since common already contains an attribute called 'style'
  # Do not ask how long it took to debug this issue :(
  home-style = import ./style;
  font-profiles = (import ../common/font-profiles.nix) (p: {
    home.packages = p;
  });
  magic-wormhole = import ./wormhole.nix;
  crypto = import ./crypto;
  headless = import ./headless;
  desktop = import ./desktop;
  editors = import ./editors;
  persistence = import ./persistence.nix;
}
// import ../common
