{pkgs, ...}: {
  programs.helix.languages = {
    language-server = {
      nil = {
        command = "${pkgs.nil}/bin/nil";
        args = ["--stdio"];
      };
      statix = {
        command = "${pkgs.statix}/bin/statix";
        args = ["check" "--stdin"];
      };
    };

    language = [
      {
        name = "nix";
        auto-format = true;
        formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
        language-servers = ["nil" "statix"];
      }
    ];
  };
}
