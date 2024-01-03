{pkgs, ...}: {
  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];
}
