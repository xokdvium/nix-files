# ❄️ Xokdvium's NixOS flake

> [!WARNING]  
> This README is currenty very heavy WIP

This repository contains my personal flake. It builds my development machines and deploys part of my infrastructure

If you don't know what nix, nixos and flakes are then please take a look at [introduction-to-flakes](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes)
by [ryan4yin](https://github.com/ryan4yin). Basically it's a functional package manager on steroids which empowers to user to build whatever they want. This flake leverages this power to configure
my machines in a declarative way how I like them. Flakes have locked dependencies which ensures that my system configuration is reproducible and works out of the box. 

## 🧬 Structure

I prefer to keep my home configuration in [home-manager](https://github.com/nix-community/home-manager) since it's not always possible to use NixOS (although not for the lack of trying).
This way I can get my development environment up and running on any distribution by using [standalone](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone) home-manager.

## 🚀 Deployment

To rebuild the system configuration run:

```bash
just rebuild
```

## 📖 Acknowledgements

I would like to highlight some of the amazing resources that guided me along my nix journey: 

- For getting me started: [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- Finally making heads and tails of flakes: [introduction-to-flakes](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes)
- Plunging me into the world of ephemeral systems: [erase-your-darlings](https://grahamc.com/blog/erase-your-darlings/)
