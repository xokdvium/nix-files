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
    ...
  } @ inputs: let
    systems = ["x86_64-linux" "aarch64-linux"];
  in
    flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [];
      };

      lints = inputs.lint-nix.lib.lint-nix rec {
        inherit pkgs;
        src = ./.;

        linters = {
        };

        formatters = {
          rustfmt = {
            ext = ".rs";
            cmd = "${pkgs.rustfmt}/bin/rustfmt --config-path ${src} $filename";
          };
        };
      };

      cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
      rustToolchain = pkgs.symlinkJoin {
        name = "rustToolchain";
        paths = with pkgs; [
          rustc
          cargo
          cargo-watch
          rust-analyzer
          rustPlatform.rustcSrc
        ];
      };

      nonRustDeps = with pkgs; [
      ];

      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          rustToolchain
          just
        ];

        buildInputs = [] ++ nonRustDeps;

        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
        RUST_BACKTRACE = "full";
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

        default = pkgs.rustPlatform.buildRustPackage {
          inherit (cargoToml.package) name version;
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };
      };

      formatter = pkgs.alejandra;
    });
}
