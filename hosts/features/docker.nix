{
  lib,
  config,
  ...
}: {
  virtualisation.docker = {
    enable = true;
  };

  environment.persistence."/persistent" = lib.mkIf config.persistence.enable {
    directories = ["/var/lib/docker"];
  };
}
