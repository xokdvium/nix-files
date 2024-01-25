{pkgs, ...}: {
  programs.helix.languages = {
    language-server.rust-analyzer = {
      command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
    };

    language = [
      {
        name = "rust";
        language-servers = ["rust-analyzer"];
        formatter = {
          command = "${pkgs.rustfmt}/bin/rustfmt";
        };
        auto-format = true;
      }
    ];
  };
}
