{pkgs, ...}: {
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ../../../secrets/keys/pgp.asc;
        trust = 5;
      }
    ];

    scdaemonSettings = {
      reader-port = "Yubico Yubi";
      disable-ccid = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    pinentryFlavor = "curses";
    enableScDaemon = true;
  };

  home.packages = with pkgs; [
    gpg-scripts
  ];
}
