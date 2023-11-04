{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

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

      devShell =
        (pkgs.mkShell.override {
          stdenv = pkgs.llvmPackages_16.stdenv;
        }) {
          nativeBuildInputs = with pkgs; [
            cmake
            python311
            doxygen
            ninja
          ];
        };
    in {
      devShells = {
        default = devShell;
      };
    });
}
