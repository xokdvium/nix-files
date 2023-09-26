# Refer to https://github.com/rayandrew/nix-config for more info
{ pkgs }:
let
  inherit (pkgs) stdenv lib;
  custom = ./custom;
in stdenv.mkDerivation {
  pname = "nvchad";
  version = "2.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "3091ea58359bb85f087499bd73fbc0a57a935c34";
    sha256 = "sha256-tkgHTag0/0jbW5Pab96oEddQJ2/GWSt1pVimQpSBz20=";
  };

  installPhase = ''
    mkdir $out
    mkdir -p "$out/lua/custom"
    cp -r * "$out/"
    cp -r ${custom}/* "$out/lua/custom/"
  '';

  meta = with lib; {
    description = "NvChad";
    homepage = "https://github.com/NvChad/NvChad";
    platforms = platforms.all;
    license = licenses.gpl3;
  };
}
