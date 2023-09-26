#!/usr/bin/env bash

usage() {
  echo "Usage: $(basename "$0") [-m]"
}

switch_home_manager() {
  PROFILE=${OPTARG}
  # TODO: do not modify env variables to enable flakes
  export NIX_CONFIG="experimental-features = nix-command flakes"
  home-manager --flake ".#${PROFILE}" switch
}

while getopts "m:" options; do
  case "${options}" in
    m)
      switch_home_manager
      ;;
    *)
      usage
      ;;
  esac
done
