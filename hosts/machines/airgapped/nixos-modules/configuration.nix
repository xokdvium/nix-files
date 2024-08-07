{
  lib,
  extraConfig,
  pkgs,
  outputs,
  hostModulesPath,
  ...
}:

let
  genUsers = outputs.lib.genUsers extraConfig.users;
in

{
  imports = map (v: hostModulesPath + "/${v}") [
    "common"
    "features/dewm/gnome.nix"
    "features/crypto.nix"
  ];

  xokdvium = {
    common = {
      style = {
        enable = true;
        preset = "catppuccin-mocha";
      };
    };
  };

  boot = {
    kernelParams = [ "copytoram" ];
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      network.enable = lib.mkForce false;
      systemd.enable = lib.mkForce false;
    };
    tmp.cleanOnBoot = lib.mkForce true;
    kernel.sysctl = {
      "kernel.unprivileged_bpf_disabled" = 1;
    };
  };

  networking = {
    hostName = "airgapped";
    # Make sure networking is disabled in every way possible.
    dhcpcd.enable = lib.mkForce false;
    dhcpcd.allowInterfaces = lib.mkForce [ ];
    interfaces = lib.mkForce { };
    firewall.enable = lib.mkForce true;
    useDHCP = lib.mkForce false;
    useNetworkd = lib.mkForce false;
    wireless.enable = lib.mkForce false;
    networkmanager.enable = lib.mkForce false;
  };

  users.users = genUsers (_: {
    initialPassword = "hunter2";
  });

  # NOTE: This does not really matter since this system is not supposed to
  # run any persistent services. The same as home.nix
  system.stateVersion = "24.05";
}
