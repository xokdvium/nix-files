{ lib, ... }:

{
  services.clamav = {
    daemon.enable = true;
    updater = {
      enable = true;
      settings = {
        DatabaseMirror = lib.mkForce "packages.microsoft.com/clamav";
      };
    };
    scanner.enable = true;
  };

  xokdvium.nixos.persistence = {
    state.dirs = [ "/var/lib/clamav" ];
  };
}
