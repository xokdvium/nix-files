{
  lib,
  config,
  ...
}: {
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

  environment.persistence."/state" = lib.mkIf config.xokdvium.nixos.persistence.enable {
    directories = ["/var/lib/clamav"];
  };
}
