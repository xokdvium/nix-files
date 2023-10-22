# Very nice reference https://www.ertt.ca/nix/shell-scripts/#org7126a49
# Also it seems possible that there's is an alternative:
# https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeShellApplication
{
  inputs,
  pkgs,
  ...
}: let
  src = builtins.readFile ./switch.sh;
  name = "switch";

  runtimeDeps = let
    nh =
      inputs.nh.packages.${pkgs.system}.default;
  in
    with pkgs; [
      git
      nix
      nh
      home-manager
    ];

  script = (pkgs.writeScriptBin name src).overrideAttrs (prev: {
    buildCommand = ''
      ${prev.buildCommand}
      patchShebangs $out
    '';
  });
in
  pkgs.symlinkJoin {
    inherit name;

    paths =
      [
        script
      ]
      ++ runtimeDeps;

    buildInputs = with pkgs; [
      makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/${name}                \
        --set PATH ${pkgs.lib.makeBinPath runtimeDeps} \
        --set USE_NH true
    '';
  }
