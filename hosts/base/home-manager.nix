{
  home-manager = {
    backupFileExtension = "backup";
  };

  programs = {
    # NOTE: This is required for home-manager.
    dconf.enable = true;
    # Make home-manager not blow up during nixos-rebuild switch with systemd
    # errors
    # https://github.com/nix-community/home-manager/blob/14b54157201fd574b0fa1b3ce7394c9d3a87fbc1/modules/misc/xfconf.nix#L70

    # For anyone wondering, the error looks something like:
    # [home-manager]: Unable to set property
    # ....
    # Then systemd service home-manager-<username> fails because home-manager
    # returns a non-zero exit code
    xfconf.enable = true;
  };
}
