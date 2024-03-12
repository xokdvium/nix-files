{ extraConfig, ... }:
let
  inherit (extraConfig.host) hostname;
in
{
  networking = {
    hostName = hostname;
    hostId = builtins.substring 0 8 (builtins.hashString "sha512" hostname);
  };
}
