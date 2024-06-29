{
  dream2nix,
  pkgs,
  fetchFromGitHub,
  symlinkJoin,
  makeWrapper,
  jdk17,
  ...
}:

let

  unwrapped = dream2nix.lib.evalModules {
    packageSets.nixpkgs = pkgs;
    modules = [
      (
        { config, dream2nix, ... }:
        {
          imports = [
            dream2nix.modules.dream2nix.nodejs-package-lock-v3
            dream2nix.modules.dream2nix.nodejs-granular-v3
          ];

          mkDerivation = {
            src = fetchFromGitHub {
              owner = "nvuillam";
              repo = "npm-groovy-lint";
              rev = "v${config.version}";
              hash = "sha256-YnCsy9VC++UjlehLZpfQ9oIPqMG782tzLIoEhY50HUc=";
            };
          };

          nodejs-package-lock-v3 = {
            packageLockFile = "${config.mkDerivation.src}/package-lock.json";
          };

          name = "npm-groovy-lint-unwrapped";
          version = "14.6.0";
        }
      )
    ];
  };

in
symlinkJoin {
  name = "npm-groovy-lint";
  paths = [ unwrapped ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/npm-groovy-lint --add-flags "--javaexecutable ${jdk17}/bin/java"
  '';
}
