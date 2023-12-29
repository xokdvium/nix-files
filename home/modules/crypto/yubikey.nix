{pkgs, ...}: {
  home.packages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    # FIXME: Add this back when dart issue gets fixed
    # yubioath-flutter
    yk-scripts
  ];
}
