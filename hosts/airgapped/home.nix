{pkgs, ...}: {
  xdg.desktopEntries = {
    yubikey-guide = {
      name = "yubikey-guide";
      genericName = "Guide to using YubiKey for GPG and SSH";
      comment = "Open the guide in a reader program";
      categories = ["Documentation"];
      exec = "${pkgs.yubikey-guide}/bin/view-yubikey-guide";
    };
  };
}
