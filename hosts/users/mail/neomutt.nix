{ pkgs, config, ... }:

{
  programs.neomutt = {
    enable = true;
    vimKeys = true;
    sort = "date";
    sidebar = {
      enable = true;
    };
    extraConfig = ''
      set edit_headers = yes
      set reverse_name = yes
    '';
  };
}
