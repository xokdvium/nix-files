{ config, ... }:

{
  hardware.nvidia-container-toolkit = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      open = false;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      powerManagement = {
        enable = true;
      };
    };
  };
}
