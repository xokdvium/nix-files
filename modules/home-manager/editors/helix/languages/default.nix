{ pkgs, ... }:
map (file: import file { inherit pkgs; }) [
  ./bash.nix
  ./cmake.nix
  ./cpp.nix
  ./dockerfile.nix
  ./git-commit.nix
  ./groovy.nix
  ./json.nix
  ./just.nix
  ./markdown.nix
  ./meson.nix
  ./nix.nix
  ./openscad.nix
  ./python.nix
  ./ruby.nix
  ./rust.nix
  ./scala.nix
  ./scheme.nix
  ./tablegen.nix
  ./toml.nix
  ./typos.nix
  ./verilog.nix
  ./yaml.nix
]
