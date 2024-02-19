files_to_clean := "~/.mozilla/firefox/xokdvium/*.backup /home/xokdvium/.zsh_history.backup"

alias f := format
alias l := lint
alias sw := switch
alias lsw := local-switch

_cleanup_backups:
  @rm -rf {{files_to_clean}}

switch *FLAGS: _cleanup_backups
  @nh os switch {{justfile_directory()}} {{FLAGS}}

boot *FLAGS: _cleanup_backups
  @nh os boot {{justfile_directory()}} {{FLAGS}}

remote-switch host url build_host="localhost":
  @nixos-rebuild switch \
    --flake "{{justfile_directory()}}#{{host}}" \
    --target-host {{url}} \
    --build-host {{build_host}} \
    --log-format internal-json |& nom --json

local-switch *FLAGS: _cleanup_backups
  @sudo nixos-rebuild switch \
    --flake "{{justfile_directory()}}" \
    --builders ""

collect-garbage:
  @nh clean all

run-workflows:
  @act -P ubuntu-22.04=ghcr.io/catthehacker/ubuntu:runner-22.04

check:
  @nix build ".#all-checks" -L

check-format:
  @nix build ".#all-formats" -L

format:
  @nix build ".#format-all"
  @result/bin/format-all

lint: check format
