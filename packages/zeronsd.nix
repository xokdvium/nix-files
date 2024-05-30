{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustfmt,
}:

rustPlatform.buildRustPackage rec {
  pname = "zeronsd";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "zeronsd";
    rev = "v${version}";
    hash = "sha256-TL0bgzQgge6j1SpZCdxv/s4pBMSg4/3U5QisjkVE6BE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  strictDeps = true;
  cargoHash = "sha256-WGap0j90obpJHiMNokCWg0Q3xIAqwvmiESg9NVnFMKE=";

  # To fix this frankly insane requirement
  # https://github.com/oxidecomputer/rustfmt-wrapper/blob/c5335c713dfd6d2a2ef917a3d0461c51f03b55db/src/lib.rs#L22
  RUSTFMT = "${rustfmt}/bin/rustfmt";

  # Tests are broken and can't be individually disabled unfortunately
  doCheck = false;

  meta = with lib; {
    description = "A DNS server for ZeroTier users";
    homepage = "https://github.com/zerotier/zeronsd";
    license = licenses.bsd3;
  };
}
