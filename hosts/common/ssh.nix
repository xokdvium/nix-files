{
  lib,
  extraConfig,
  config,
  outputs,
  ...
}: let
  genUsers = outputs.lib.genUsers extraConfig.users;
in {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users = genUsers (_: {
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../secrets/keys/ssh.pub)
    ];
  });

  environment.persistence."/persistent" = lib.mkIf config.persistence.enable {
    files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}
