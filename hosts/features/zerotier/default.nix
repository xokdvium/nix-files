{
  pkgs,
  lib,
  config,
  ...
}: let
  networkId = "a09acf023353c355";
in {
  services = {
    zerotierone = {
      enable = true;
      joinNetworks = [networkId];
    };

    resolved = {
      enable = true;
    };
  };

  systemd = {
    network = {
      enable = true;
      wait-online.enable = false;
    };

    timers."zerotier-systemd-manager" = {
      description = "Update zerotier per-interface DNS settings";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "1min";
      };
    };

    services.zerotier-systemd-manager = {
      description = "Update zerotier per-interface DNS settings";
      wants = ["zerotierone.target"];
      after = ["zerotierone.target"];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.zerotier-systemd-manager}/bin/zerotier-systemd-manager";
      };
    };
  };

  environment.persistence."/persistent" = lib.mkIf config.extraOptions.persistence.enable {
    directories = ["/var/lib/zerotier-one"];
  };
}
