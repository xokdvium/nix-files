# https://github.com/jneem/probe-rs-rules
{ stdenvNoCC, fetchurl, ... }:
stdenvNoCC.mkDerivation {
  pname = "probe-rs-rules";
  version = "0";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/probe-rs/webpage/6c4547a3abf2a562fa742e5f7dddf5f54d2a6534/src/static/files/69-probe-rs.rules";
    hash = "sha256-SdwESnOuvOKMsTvxyA5c4UwtcS3kU33SlNttepMm7HY=";
  };

  dontUnpack = true;

  # https://bbs.archlinux.org/viewtopic.php?id=164676
  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    substitute $src $out/lib/udev/rules.d/69-probe-rs.rules --replace-fail ", GROUP=\"plugdev\"" ""
  '';
}
