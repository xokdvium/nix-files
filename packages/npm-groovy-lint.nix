{
  fetchFromGitHub,
  makeWrapper,
  jdk17,
  buildNpmPackage,
  ...
}:

buildNpmPackage rec {
  pname = "npm-groovy-lint";
  version = "14.6.0";

  src = fetchFromGitHub {
    owner = "nvuillam";
    repo = "npm-groovy-lint";
    rev = "v${version}";
    hash = "sha256-YnCsy9VC++UjlehLZpfQ9oIPqMG782tzLIoEhY50HUc=";
  };

  npmDepsHash = "sha256-muEAhi7pnhZUCrW/fOKRPkEDCLhAGKN/AH3rlPaLrGM=";

  buildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/npm-groovy-lint --add-flags "--javaexecutable ${jdk17}/bin/java"
  '';
}
