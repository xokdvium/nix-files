{
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 rec {
  pname = "hiddiy-next";
  version = "2.5.7";

  src = fetchurl {
    url = "https://github.com/hiddify/hiddify-next/releases/download/v${version}/Hiddify-Linux-x64.AppImage";
    hash = "sha256-5RqZ6eyurRtoOVTBLZqoC+ANi4vMODjlBWf3V4GXtMg=";
  };

  extraPkgs =
    pkgs: with pkgs; [
      libepoxy
    ];
}
