#!/usr/bin/env bash

USE_NH=false # Use nh (https://github.com/viperML/nh) to switch

usage() {
  echo "Usage: $(basename "$0") [-n] [-m PROFILE] [-s PROFILE]"
}

switch_home_manager() {
  if ${USE_NH}; then
    nh home switch ./ -c "${OPTARG}"
  else
    nix-shell --command "home-manager --flake .#${OPTARG} switch"
  fi
}

switch_system() {
  if ${USE_NH}; then
    nh os switch ./ -H "${OPTARG}"
  else
    nix-shell --command "sudo nixos-rebuild --flake .#${OPTARG} switch"
  fi
}

while getopts "nm:s:" options; do
  case "${options}" in
    n)
      USE_NH=true
      ;;
    m)
      switch_home_manager
      ;;
    s)
      switch_system
      ;;
    *)
      usage
      ;;
  esac
done
