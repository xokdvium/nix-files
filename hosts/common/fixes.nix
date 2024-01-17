# Here's my growing collection of various workarounds that cost my valueable
# time and sanity
_: {
  # Make home-manager not blow up during nixos-rebuild switch with systemd
  # errors
  # https://github.com/nix-community/home-manager/blob/14b54157201fd574b0fa1b3ce7394c9d3a87fbc1/modules/misc/xfconf.nix#L70

  # For anyone wondering, the error looks something like:
  # [home-manager]: Unable to set property
  # ....
  # Then systemd service home-manager-<username> fails because home-manager
  # returns a non-zero exit code
  # What boggles my mind is why this is necessary.... Maybe something can be
  # upstreamed possibly? Or at least properly documented in an unrelated source
  # file
  programs.xfconf.enable = true;

  # NOTE: This is required for home-manager
  programs.dconf.enable = true;
}
