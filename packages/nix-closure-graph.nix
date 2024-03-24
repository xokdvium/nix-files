{
  lib,
  stdenv,
  jq,
  graphviz,
  makeWrapper,
  coreutils,
  nix,
  git,
  fetchFromGitHub,
  ...
}:
let
  lf-dotfiles = fetchFromGitHub {
    owner = "lf-";
    repo = "dotfiles";
    rev = "5332dd44b021069433805bca36949ce256de7a19";
    hash = "sha256-IHiOvO6mCVUxSfjJMNrrtIdtJkGF5T+0NnlPxgeIYEk=";
  };
in
stdenv.mkDerivation {
  pname = "nix-closure-graph";
  version = "0-unstable-2024-03-09";

  src = "${lf-dotfiles}/programs/nix-closure-graph";
  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    patchShebangs nix-closure-graph
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -T nix-closure-graph $out/bin/nix-closure-graph
    install -Dm644 -T nix-path-info-graphviz.jq $out/bin/nix-path-info-graphviz.jq
    install -Dm644 -T nix-path-info-lg.jq $out/bin/nix-path-info-lg.jq
    install -Dm644 -T lib.jq $out/bin/lib.jq
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/nix-closure-graph --set PATH ${
      lib.makeBinPath [
        coreutils
        jq
        graphviz
        nix
        git
      ]
    }
  '';
}
