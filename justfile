rebuild:
  sudo nixos-rebuild switch --flake "{{justfile_directory()}}"

run-workflows:
  act -P ubuntu-22.04=ghcr.io/catthehacker/ubuntu:runner-22.04

check:
  nix build ".#all-checks" -L

check-format:
  nix build ".#all-formats" -L

format:
  nix build ".#format-all"
  result/bin/format-all
