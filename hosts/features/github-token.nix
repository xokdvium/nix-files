# https://discourse.nixos.org/t/flakes-provide-github-api-token-for-rate-limiting/18609/4
{ config, ... }:

{
  sops.secrets."github-pat" = {
    sopsFile = ../../secrets/github/secrets.yaml;
    mode = "0440";
    group = "keys";
  };

  nix.extraOptions = ''
    !include ${config.sops.secrets."github-pat".path}
  '';
}
