# https://www.github.com/raviqqe/schemat/pull/149

{
  fenix,
  makeRustPlatform,
  lib,
  fetchFromGitHub,
  system,
}:

let
  toolchain = fenix.packages."${system}".minimal.toolchain;
  rustNightlyPlatform = makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in

rustNightlyPlatform.buildRustPackage {
  pname = "schemat";
  version = "0.1.23-unstable-2024-08-16";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "schemat";
    rev = "47e03f7d208043335a4f19e335ab01e598bf4bd3";
    hash = "sha256-UEEGB8aUSIGC+SpQavD2oyB13pTpnYf7pBYVWw90jM8=";
  };

  cargoHash = "sha256-n3sqw+UUjImsgGE5lvseytp5cKdvKecGzl2Zm4EJxrY=";

  meta = with lib; {
    description = "Code formatter for Scheme, Lisp, and any S-expressions";
    repository = "https://github.com/raviqqe/schemat";
    license = licenses.unlicense;
    maintainers = with maintainers; [ xokdvium ];
    mainProgram = "schemat";
  };
}
