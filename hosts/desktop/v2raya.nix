{
  services.v2raya = {
    enable = true;
  };

  xokdvium.nixos.persistence = {
    persist.dirs = [ "/etc/v2raya" ];
  };
}
