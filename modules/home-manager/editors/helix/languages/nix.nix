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

      nixd = {
        command = "${pkgs.nixd}/bin/nixd";
      };
    };

    language = [
      {
        name = "nix";
        auto-format = true;
        formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
        language-servers = ["nixd" "nil" "statix" "typos-lsp"];
      }
    ];
  };
}
