{
  lib,
  extraConfig,
  modulesPath,
  config,
  pkgs,
  ...
}: let
  genUsers = f:
    lib.genAttrs (builtins.attrNames
      extraConfig.users)
    (name: f (builtins.getAttr name extraConfig.users));
in {
  imports = [
    ../common
    ../features/dewm/gnome.nix
    ../features/crypto.nix
  ];

  boot = {
    kernelParams = ["copytoram"];
    initrd.network.enable = false;
    tmp.cleanOnBoot = true;
    kernel.sysctl = {
      "kernel.unprivileged_bpf_disabled" = 1;
    };
  };

  # Make sure networking is disabled in every way possible.
  networking = {
    dhcpcd.enable = false;
    dhcpcd.allowInterfaces = [];
    interfaces = {};
    firewall.enable = true;
    useDHCP = false;
    useNetworkd = false;
    wireless.enable = false;
    networkmanager.enable = lib.mkForce false;
  };

  users.users = genUsers (_: {initialPassword = "";});
}
