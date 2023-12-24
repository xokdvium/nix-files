{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    lint-nix.url = "github:xc-jp/lint.nix";

    mini-compile-commands = {
      url = "github:danielbarter/mini_compile_commands";
      flake = false;
    };
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

      clang-tools = pkgs.clang-tools_17;
      lints = inputs.lint-nix.lib.lint-nix {
        inherit pkgs;
        src = ./.;

        linters = {
          ruff = {
            ext = ".py";
            cmd = "${pkgs.ruff}/bin/ruff $filename";
          };
        };

        formatters = {
          clang-format = {
            ext = [".c" ".cpp" ".h" ".hpp" ".cc"];
            cmd = "${clang-tools}/bin/clang-format";
            stdin = true;
          };

          black = {
            ext = ".py";
            cmd = "${pkgs.black}/bin/black $filename";
          };
        };
      };

      devShell =
        (pkgs.mkShell.override {
          stdenv = pkgs.llvmPackages_17.stdenv;
        }) {
          nativeBuildInputs = with pkgs; [
            cmake
            python311
            doxygen
            ninja
            clang-tools
            act
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

      formatter = pkgs.alejandra;
    });
}
