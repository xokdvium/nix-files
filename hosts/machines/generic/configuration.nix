{
  lib,
  outputs,
  extraConfig,
  ...
}:

let
  genUsers = outputs.lib.genUsers extraConfig.users;
in

{
  imports = [ ../../common ];

  networking = {
    hostName = "generic";
  };

  users.users = genUsers (_: {
    initialPassword = "";
  });

  networking.useDHCP = lib.mkDefault true;

  boot = {
    initrd.systemd.enable = lib.mkForce false;
  };
}
