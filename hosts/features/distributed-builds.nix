{
  pkgs,
  lib,
  ...
}: {
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "nebulinx.jawphungy.corp";
        systems = ["x86_64-linux" "aarch64-linux"];
        protocol = "ssh-ng";
        maxJobs = 8;
        speedFactor = 16;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        sshUser = "builder";
        publicHostKey = builtins.readFile ../../secrets/keys/nebulinx-host.base64;
      }
    ];

    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
