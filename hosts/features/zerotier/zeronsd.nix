{
  pkgs,
  config,
  ...
}: let
  networkId = "a09acf023353c355";
  domain = "jawphungy.corp";
in {
  sops.secrets.zerotier-api-token = {
    sopsFile = ./secrets.yaml;
  };

  systemd.services."zeronsd-${networkId}" = let
    tokenPath = config.sops.secrets.zerotier-api-token.path;
  in {
    description = "zeronsd for network ${networkId}";
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target" "run-secrets.d.mount"];
    after = ["zerotierone.target" "run-secrets.d.mount"];

    unitConfig = {
      RequiresMountsFor = "${tokenPath}";
    };

    serviceConfig = {
      ExecStart = "${pkgs.zeronsd}/bin/zeronsd start -t ${tokenPath} -w -d ${domain} ${networkId}";
      Restart = "always";
      TimeoutStopSec = 30;
    };
  };
}
