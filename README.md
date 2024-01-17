# ❄️ Xokdvium's NixOS flake

> [!WARNING]  
> This README is currenty very heavy WIP

This repository contains my personal flake. It builds my development machines and deploys part of my infrastructure

If you don't know what nix, nixos and flakes are then please take a look at [introduction-to-flakes](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes)
by [ryan4yin](https://github.com/ryan4yin). Basically it's a functional package manager on steroids which empowers to user to build whatever they want. This flake leverages this power to configure
my machines in a declarative way. Flakes have locked dependencies which ensures that my system configuration is reproducible and works out of the box. 

## 🧬 Structure

I prefer to keep my home configuration in [home-manager](https://github.com/nix-community/home-manager) since it's not always possible to use NixOS (although not for the lack of trying).
This way I can get my development environment up and running on any distribution by using [standalone](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone) home-manager.

## 🔧 Development

This flake provies a `devShell` and `direnv` configuration.
The latter is most convenient (if you have `nix-direnv` installed):

```bash
direnv allow
```

Otherwise you can enter the shell via `nix-shell` or `nix develop` commands.
Both are supported and versioned with `flake.lock` file.
The flake has several formatters configured via [lint.nix](https://github.com/xc-jp/lint.nix). Definitions can be found at
[lints.nix](./lints.nix). This file is my go-to for preconfigured linters and formatters for CI/CD and development.
All files can be formatted and checked with the following command:

```bash
just lint
```

## 🚀 Deployment

You can view all targets by running `just -l`:
```bash
❯ just -l
Available recipes:
    check
    check-format
    collect-garbage
    format
    f               # alias for `format`
    lint
    l               # alias for `lint`
    remote-switch host url build_host="localhost"
    run-workflows
    switch *FLAGS
    sw *FLAGS       # alias for `switch`
```

To rebuild the system configuration run:

```bash
just switch
```

To remotely deploy the configuration you can run:
```bash
just remote-switch {{hostname}} {{user@address}} {{build-host}}
```

## 📖 Acknowledgements

I would like to highlight some of the amazing resources that guided me along my nix journey: 

- For getting me started: [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- Finally making heads and tails of flakes: [introduction-to-flakes](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes)
- Plunging me into the world of ephemeral systems: [erase-your-darlings](https://grahamc.com/blog/erase-your-darlings/)
