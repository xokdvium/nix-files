{
  # Disable flaky service which causes rebuild failures.
  systemd.services.NetworkManager-wait-online.enable = false;
}
