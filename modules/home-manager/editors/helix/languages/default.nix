{ pkgs, ... }:
map (file: import file { inherit pkgs; }) [
  ./just.nix
  ./cpp.nix
  ./json.nix
  ./cmake.nix
  ./bash.nix
  ./nix.nix
  ./ruby.nix
  ./rust.nix
  ./yaml.nix
  ./toml.nix
  ./markdown.nix
  ./typos.nix
  ./python.nix
  ./verilog.nix
]
