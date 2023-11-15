# Rebuild NixOS configuration
rebuild:
  sudo nixos-rebuild switch --flake "{{justfile_directory()}}"
