{
  config,
  extraConfig,
  lib,
  ...
}:

let
  inherit (extraConfig) users;
  user = builtins.getAttr config.home.username users;
in

{
  imports = [ ../../../hosts/base/nixpkgs.nix ];

  # NOTE: Because being a trusted-user is really bad, this config has moved away from that.
  # But some home-manager modules really like to add their own substituters. This
  # leads to nix spamming you with warnings. Doesn't look like this actually removes
  # any warnings, but this at least explicitly dumps all custom substituters from user config.
  nix.settings = {
    extra-substituters = lib.mkForce [ ];
    extra-trusted-public-keys = lib.mkForce [ ];
  };

  home = {
    homeDirectory = user.homePath;
  };

  systemd.user.startServices = "sd-switch";
}
