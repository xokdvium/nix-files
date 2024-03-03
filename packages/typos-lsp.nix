{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "typos-lsp";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "tekumara";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8mCK/NKik1zf6hqJN4pflDbtFALckHR/8AQborbOoHs=";
  };

  cargoHash = "sha256-aL7arYAiTpz9jy7Kh8u7OJmPMjayX4JiKoa7u8K0UiE=";
}
