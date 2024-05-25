{ lib, config, ... }:

{
  services.v2raya = {
    enable = true;
  };

  environment.persistence."/state" = lib.mkIf config.xokdvium.nixos.persistence.enable {
    directories = [ "/etc/v2raya" ];
  };
}
