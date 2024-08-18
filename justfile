files_to_clean := "~/.mozilla/firefox/xokdvium/*.backup /home/xokdvium/.zsh_history.backup"

alias f := format
alias l := lint
alias sw := switch
alias lsw := local-switch
alias r := run-workflows

_cleanup_backups:
    rm -rf {{ files_to_clean }}

switch *FLAGS: _cleanup_backups
    just reveal
    nh os switch {{ justfile_directory() }} {{ FLAGS }}
    just hide

boot *FLAGS: _cleanup_backups
    nh os boot {{ justfile_directory() }} {{ FLAGS }}

local-switch *FLAGS: _cleanup_backups
    nh os switch {{ justfile_directory() }} -- --builders ""

collect-garbage:
    nh clean all

run-workflows:
    act -P ubuntu-22.04=ghcr.io/catthehacker/ubuntu:runner-22.04

check:
    nix flake check --accept-flake-config

check-format:
    nix flake check --accept-flake-config

format:
    nix fmt

lint: check format

update:
    nix flake update --accept-flake-config

reveal:
    git secret reveal -f
    git add --all

hide:
    git secret hide -d
    git add --all
