{
  lib,
  config,
  ...
}: {
  networking = {
    networkmanager.enable = lib.mkOverride 75 true;
    wireless.enable = lib.mkOverride 75 false;
  };

  environment.persistence."/persistent" = lib.mkIf config.persistence.enable {
    directories = ["/etc/NetworkManager"];
  };
}
