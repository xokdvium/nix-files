{
  lib,
  config,
  ...
}: {
  virtualisation.docker = {
    enable = true;
  };

  environment.persistence."/persistent" = lib.mkIf config.xokdvium.nixos.persistence.enable {
    directories = ["/var/lib/docker"];
  };
}
