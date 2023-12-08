{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
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

      gems = pkgs.bundlerEnv {
        # FIXME: Change this name
        name = "gems-for-some-project";
        gemdir = ./.;
      };

      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          gems
          gems.wrappedRuby
          bundix
          bundler
        ];
      };
    in {
      devShells = {
        default = devShell;
      };
    });
}
