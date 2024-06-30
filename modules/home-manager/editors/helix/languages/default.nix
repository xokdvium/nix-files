{ pkgs, ... }:
map (file: import file { inherit pkgs; }) [
  ./bash.nix
  ./cmake.nix
  ./cpp.nix
  ./dockerfile.nix
  ./git-commit.nix
  ./json.nix
  ./just.nix
  ./markdown.nix
  ./nix.nix
  ./python.nix
  ./ruby.nix
  ./rust.nix
  ./scala.nix
  ./toml.nix
  ./typos.nix
  ./verilog.nix
  ./yaml.nix
  ./tablegen.nix
  ./openscad.nix
  ./groovy.nix
]
