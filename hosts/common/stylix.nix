{ inputs, lib, ... }:

{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = lib.mkOverride 75 true;
    homeManagerIntegration = {
      followSystem = lib.mkForce false;
      autoImport = lib.mkForce false;
    };
  };
}
