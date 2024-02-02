{
  lib,
  config,
  ...
}: {
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "hourly";
      flags = ["--all"];
    };
  };

  environment.persistence."/state" = lib.mkIf config.xokdvium.nixos.persistence.enable {
    directories = ["/var/lib/docker"];
  };
}
