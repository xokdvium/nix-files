{ inputs, lib, ... }:
{
  imports = [
    "${inputs.nix-mineral}/nix-mineral.nix"
  ];

  services = {
    resolved.dnssec = lib.mkForce "false";
  };
}
