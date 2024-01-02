{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    lint-nix.url = "github:xc-jp/lint.nix";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    lint-nix,
    ...
  } @ inputs: let
    systems = ["x86_64-linux" "aarch64-linux"];
  in
    flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [];
      };

      lints = lint-nix.lib.lint-nix rec {
        inherit pkgs;
        src = ./.;
        linters = {};
        formatters = {
          rubyfmt = {
            ext = [".rb"];
            cmd = "${pkgs.rubyfmt}/bin/rubyfmt --in-place $filename";
          };
        };
      };

      gems = pkgs.bundlerEnv {
        name = "{{gems-for-project-name}}";
        gemdir = ./.;
      };

      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          gems
          gems.wrappedRuby
          bundix
          bundler
          just
        ];
      };
    in {
      devShells = {
        default = devShell;
      };

      packages = {
        inherit
          (lints)
          all-checks
          all-formats
          all-lints
          format-all
          ;
      };
    });
}
