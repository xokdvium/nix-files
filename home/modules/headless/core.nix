{
  outputs,
  pkgs,
  lib,
  config,
  extraConfig,
  ...
}: let
  inherit (extraConfig) users;
  user = builtins.getAttr config.home.username users;
in {
  home = {
    homeDirectory = user.homePath;
    stateVersion = "23.11";
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes" "repl-flake"];
  };

  systemd.user.startServices = "sd-switch";
}
