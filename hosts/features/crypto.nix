{pkgs, ...}: {
  # FIXME: Currently polkit actions do not register correctly.
  # TODO: Remove this workaround when the issue gets resolved in the package
  environment.systemPackages = with pkgs; [
    pcscliteWithPolkit.out
  ];

  services = {
    pcscd.enable = true;
    udev.packages = with pkgs; [
      yubikey-personalization
    ];
  };
}
