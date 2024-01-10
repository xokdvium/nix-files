_: {
  nix = {
    distributedBuilds = true;

    # NOTE: Domain names are those set in an zerotier private netowork.
    # In order to use those a zerotier feature is necessary for the host.
    buildMachines = [
      (let
        threads = 8;
        hostKeyFile = ../../secrets/host-keys/nebulinx-host.base64;
      in {
        hostName = "nebulinx.jawphungy.home.arpa";
        systems = ["x86_64-linux" "aarch64-linux"];
        protocol = "ssh-ng";
        maxJobs = threads;
        speedFactor = 16;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        sshUser = "builder";
        publicHostKey = builtins.readFile hostKeyFile;
      })
    ];

    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
