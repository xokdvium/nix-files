{ ... }:
{
  imports = [ ./common ];
  services = {
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
  };
}
