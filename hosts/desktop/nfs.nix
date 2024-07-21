# https://www.github.com/NixOS/nixpkgs/issues/76671
{
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;
}
