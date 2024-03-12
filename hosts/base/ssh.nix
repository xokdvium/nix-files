{
  lib,
  extraConfig,
  config,
  outputs,
  ...
}:
let
  genUsers = outputs.lib.genUsers (extraConfig.users // { root.name = "root"; });
in
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = lib.mkOverride 75 false;
      KbdInteractiveAuthentication = lib.mkOverride 75 false;
      PermitRootLogin = lib.mkOverride 75 "no";
    };
  };

  users.users = genUsers (_: {
    openssh.authorizedKeys.keys =
      let
        directory = ../../secrets/user-keys;
      in
      builtins.map (file: builtins.readFile (directory + "/${file}")) (
        builtins.attrNames (lib.attrsets.filterAttrs (_n: v: v == "regular") (builtins.readDir directory))
      );
  });

  environment.persistence."/persistent" = lib.mkIf config.xokdvium.nixos.persistence.enable {
    files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}
