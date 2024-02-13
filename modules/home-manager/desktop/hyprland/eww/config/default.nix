{
  stdenv,
  lib,
}:
stdenv.mkDerivation {
  pname = "eww-config-base";
  version = "0.0.1";
  src = lib.cleanSource ./tree;
  installPhase = ''
    cp -r ./. $out
  '';
}
