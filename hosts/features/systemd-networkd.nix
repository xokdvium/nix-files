{
  systemd = {
    network = {
      enable = true;
      wait-online.enable = false;
    };
  };

  services = {
    resolved = {
      enable = true;
      dnssec = "false";
      llmnr = "true";
    };
  };
}
