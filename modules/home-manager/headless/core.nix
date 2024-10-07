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
  # leads to nix spamming you with warnings.
  # HACK: To silince warnings like:
  # warning: ignoring the client-specified setting 'trusted-public-keys', because it is a restricted setting and you are not a trusted user
  nix.settings = lib.mkForce { };

  home = {
    homeDirectory = user.homePath;
  };

  systemd.user.startServices = "sd-switch";
}
