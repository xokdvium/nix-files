{
  lib,
  outputs,
  extraConfig,
  ...
}: let
  genUsers = outputs.lib.genUsers extraConfig.users;
in {
  imports = [
    ../../common
  ];

  users.users = genUsers (_: {
    initialPassword = "";
  });

  services = {
    octoprint = {
      enable = true;
      plugins = plugins:
        with plugins; [
          themeify
          titlestatus
          dashboard
          abl-expert
          bedlevelvisualizer
          costestimation
          displayprogress
          marlingcodedocumentation
          telegram
        ];
    };
  };

  networking.useDHCP = lib.mkDefault true;
}
