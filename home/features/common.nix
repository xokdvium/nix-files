{
  pkgs,
  inputs,
  lib,
  config,
  outputs,
  ...
}: {
  imports =
    [
      ./cli
      ./kitty
      ./styles

      inputs.stylix.homeManagerModules.stylix
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
    bitwarden
  ];
}
