{ outputs, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-25.9.0" # FIXME: Remove this when obsidian gets bumped
      ];
    };
    overlays = builtins.attrValues outputs.overlays;
  };
}
