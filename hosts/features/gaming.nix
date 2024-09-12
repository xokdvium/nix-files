{ pkgs, ... }:

{
  programs = {
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        luxtorpeda
        proton-ge-custom
      ];
    };
  };
}
