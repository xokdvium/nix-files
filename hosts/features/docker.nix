{
  lib,
  config,
  ...
}: {
  virtualisation.docker = {
    enable = true;
  };

  environment.persistence."/state" = lib.mkIf config.xokdvium.nixos.persistence.enable {
    directories = ["/var/lib/docker"];
  };
}
