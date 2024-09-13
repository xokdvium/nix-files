{ rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "binsider";
  version = "0.1.0-unstable-2024-09-13";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "binsider";
    rev = "52192df05b7c508076cdf8baad831f08305b37f8";
    hash = "sha256-sNfgYUEIjGkDKeKPqgY4QM2WdYi4TZ3PlLksCoZFs8U=";
  };

  cargoHash = "sha256-vBGhm5XFLboW6T/39tGNk3riCnE1PU7V/IhgzDepC34=";
  doCheck = false;
}
