{ inputs, self, ... }:

let

  inherit (inputs)
    nixpkgs
    attic
    yazi
    nix-vscode-extensions
    ;

  inherit (self) outputs;
  inherit (nixpkgs) lib;

  getDefaultOverlayAttrs =
    attrs: lib.genAttrs (lib.attrNames attrs) (name: attrs.${name}.overlays.default);
in

{
  flake.overlays = lib.mergeAttrsList [
    {
      helix-master = import ./helix.nix { inherit inputs; };
      nixd-main = import ./nixd-main.nix { inherit inputs; };
      additions =
        final: _:
        import ../packages {
          pkgs = final;
          inherit inputs;
        };
      extend-lib-nix-files = _final: prev: {
        lib = prev.lib.extend (_: _: import ../lib { inherit inputs outputs; });
      };
    }
    (getDefaultOverlayAttrs { inherit attic yazi nix-vscode-extensions; })
  ];
}
