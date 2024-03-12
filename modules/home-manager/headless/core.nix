{ config, extraConfig, ... }:
let
  inherit (extraConfig) users;
  user = builtins.getAttr config.home.username users;
in
{
  imports = [ ../../../hosts/base/nix.nix ];

  home = {
    homeDirectory = user.homePath;
  };

  systemd.user.startServices = "sd-switch";
}
