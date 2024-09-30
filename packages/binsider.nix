{ rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "binsider";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "binsider";
    rev = "v0.2.0";
    hash = "sha256-VnWLslelEAXuSy7XnxrdgSkXqTrd+Ni7lQFsB2P+ILs=";
  };

  cargoHash = "sha256-eBZ7zUOucarzdxTjHecUxGqUsKTQPaaotOfs/v0MxHk=";
  doCheck = false;
}
