{ pkgs, ... }:

{
  programs = {
    steam = {
      enable = true;
    };
  };

  chaotic.steam = {
    extraCompatPackages = with pkgs; [
      luxtorpeda
      proton-ge-custom
    ];
  };
}
