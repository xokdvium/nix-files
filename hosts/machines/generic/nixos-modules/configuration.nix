{
  lib,
  outputs,
  extraConfig,
  hostModulesPath,
  ...
}:

let
  genUsers = outputs.lib.genUsers extraConfig.users;
in

{
  imports = [ "${hostModulesPath}/common" ];

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
