{pkgs, ...}: {
  home.packages = with pkgs; [
    termshark
  ];
}
