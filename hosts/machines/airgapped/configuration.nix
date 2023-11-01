{
  lib,
  extraConfig,
  outputs,
  ...
}: let
  genUsers = outputs.lib.genUsers extraConfig.users;
in {
  imports = [
    ../../common
    ../../features/dewm/gnome.nix
    ../../features/crypto.nix
  ];

  boot = {
    kernelParams = ["copytoram"];
    initrd.network.enable = lib.mkForce false;
    tmp.cleanOnBoot = lib.mkForce true;
    kernel.sysctl = {
      "kernel.unprivileged_bpf_disabled" = 1;
    };
  };

  # Make sure networking is disabled in every way possible.
  networking = {
    dhcpcd.enable = lib.mkForce false;
    dhcpcd.allowInterfaces = lib.mkForce [];
    interfaces = lib.mkForce {};
    firewall.enable = lib.mkForce true;
    useDHCP = lib.mkForce false;
    useNetworkd = lib.mkForce false;
    wireless.enable = lib.mkForce false;
    networkmanager.enable = lib.mkForce false;
  };

  users.users = genUsers (_: {initialPassword = "";});
}
