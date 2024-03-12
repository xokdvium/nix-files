{
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # NOTE: Impermanence bind mounts are not available at boot to sops-nix,
  # so this is a workaround
  sops = lib.mkIf config.xokdvium.nixos.persistence.enable {
    gnupg.sshKeyPaths = [ "/persistent/etc/ssh/ssh_host_rsa_key" ];

    age.sshKeyPaths = [ "/persistent/etc/ssh/ssh_host_ed25519_key" ];
  };
}
