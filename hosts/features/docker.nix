{
  virtualisation.docker = {
    enable = true;
  };

  xokdvium.nixos.persistence = {
    state.dirs = [ "/var/lib/docker" ];
  };
}
