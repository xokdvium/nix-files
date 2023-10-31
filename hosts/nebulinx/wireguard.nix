{
  config,
  extraConfig,
  ...
}: {
  sops.secrets = {
    "wireguard/finland/preshared" = {
      sopsFile = extraConfig.host.secretsFile;
    };

    "wireguard/finland/private" = {
      sopsFile = extraConfig.host.secretsFile;
    };
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [
        "10.8.0.5/24"
      ];

      peers = [
        {
          publicKey = "iDyk9VPF+SAasAzFML84+0QJyvQuoQxoErC52H5AVPo=";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "185.233.82.112:51820";
          persistentKeepalive = 25;
          presharedKeyFile = config.sops.secrets."wireguard/finland/preshared".path;
        }
      ];

      privateKeyFile = config.sops.secrets."wireguard/finland/private".path;
    };
  };
}
