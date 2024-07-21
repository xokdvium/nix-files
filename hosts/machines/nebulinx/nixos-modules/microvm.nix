{ config, inputs, ... }:

{
  imports = [ inputs.microvm.nixosModules.host ];

  systemd.network = {
    netdevs."10-microvm".netdevConfig = {
      Kind = "bridge";
      Name = "microvm";
    };
    networks = {
      "10-microvm" = {
        matchConfig.Name = "microvm";
        addresses = [ { addressConfig.Address = "10.139.61.1/24"; } ];
      };
      "11-microvm" = {
        matchConfig.Name = "vm-nextcloud";
        networkConfig.Bridge = "microvm";
      };
    };
  };

  microvm = {
    vms.nextcloud-vm = {
      autostart = true;
      config = {
        microvm = {
          vcpu = 2;
          mem = 2560;
          hypervisor = "qemu";

          shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
            }
          ];

          # https://serverfault.com/questions/40712/what-range-of-mac-addresses-can-i-safely-use-for-my-virtual-machines
          # https://serverfault.com/questions/299556/how-to-generate-a-random-mac-address-from-the-linux-command-line
          # printf '%02x' $((0x$(od /dev/urandom -N1 -t x1 -An | cut -c 2-) & 0xFE | 0x02)); od /dev/urandom -N5 -t x1 -An | sed 's/ /:/g'
          interfaces = [
            {
              type = "tap";
              id = "vm-nextcloud";
              mac = "e2:08:9a:04:b4:4e";
            }
          ];
        };

        users.users.root.openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;

        services = {
          getty.autologinUser = "root";
          openssh = {
            enable = true;
            settings.PermitRootLogin = "yes";
            openFirewall = true;
          };
        };

        networking = {
          hostName = "nextcloud-vm-host";
          usePredictableInterfaceNames = true;
        };

        systemd.network = {
          enable = true;
          networks."20-lan" = {
            matchConfig.Name = "enp0s3";
            networkConfig = {
              Address = [ "10.139.61.16/24" ];
            };
          };
        };

        system.stateVersion = config.system.nixos.version;
      };
    };
  };
}
