{
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../home/modules/styling/style.nix
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    autoEnable = lib.mkOverride 75 true;
    homeManagerIntegration = {
      followSystem = lib.mkForce false;
      autoImport = lib.mkForce false;
    };

    targets = {
      grub = {
        useImage = lib.mkDefault false;
        enable = lib.mkDefault false;
      };

      plymouth.blackBackground = lib.mkDefault true;
    };
  };
}
