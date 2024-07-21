{ config, ... }:

{
  virtualisation.docker = {
    enableNvidia = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      open = false;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      powerManagement = {
        enable = true;
      };
    };
  };
}
