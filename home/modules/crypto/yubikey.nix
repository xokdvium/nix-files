{pkgs, ...}: {
  home.packages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    yubioath-flutter
    yk-scripts
  ];
}
