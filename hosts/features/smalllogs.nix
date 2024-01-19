_: {
  services.journald = {
    storage = "persistent";
    extraConfig = ''
      SystemMaxUse=64M
    '';
  };
}
