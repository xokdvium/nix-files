{
  programs = {
    thunderbird = {
      enable = true;
      profiles = {
        default = {
          isDefault = true;
        };
      };
    };
  };

  xokdvium.home.persistence = {
    persist.dirs = [ ".thunderbird" ];
  };
}
