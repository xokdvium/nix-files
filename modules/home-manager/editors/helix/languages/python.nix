{ pkgs, ... }:
{
  programs.helix.languages = {
    language = [
      {
        name = "python";
        auto-format = true;
        formatter = {
          command = "${pkgs.black}/bin/black";
          args = [ "-" ];
        };
      }
    ];
  };
}
