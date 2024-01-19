{
  config,
  extraConfig,
  ...
}: let
  inherit (extraConfig) users;
  user = builtins.getAttr config.home.username users;
in {
  imports = [
    ../../../hosts/base/nix.nix
  ];

  home = {
    homeDirectory = user.homePath;
    stateVersion = "23.11";
  };

  systemd.user.startServices = "sd-switch";
}
