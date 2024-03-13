{ config, ... }:
let
  additionalVariables = {
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
in
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
    };
  };

  environment = {
    sessionVariables = additionalVariables;
    variables = additionalVariables;
  };
}
