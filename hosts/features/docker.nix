{
  lib,
  config,
  ...
}: {
  virtualisation.docker = {
    enable = true;
  };

  environment.persistence."/persistent" = lib.mkIf config.extraOptions.persistence.enable {
    directories = ["/var/lib/docker"];
  };
}
