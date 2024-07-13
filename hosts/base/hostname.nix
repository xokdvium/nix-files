{ config, ... }:

{
  networking = {
    hostId = builtins.substring 0 8 (builtins.hashString "sha512" config.networking.hostName);
  };
}
