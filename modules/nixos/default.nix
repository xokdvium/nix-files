{
  font-profiles = (import ../common/font-profiles.nix) (p: {
    environment.systemPackages = p;
  });
  zfs = import ./zfs.nix;
  immutable-users = import ./immutable-users.nix;
  persistence = import ./persistence.nix;
  auto-update = import ./auto-update.nix;
  probe-rs-rules = import ./probe-rs-rules.nix;
}
// import ../common
