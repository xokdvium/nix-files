{pkgs, ...}: {
  programs.helix.languages = {
    language-server.solargraph = {
      command = "${pkgs.rubyPackages_3_3.solargraph}/bin/solargraph";
      args = ["stdio"];
    };

    language = [
      {
        name = "ruby";
        language-servers = ["solargraph"];
        auto-format = true;
        formatter = {
          command = "${pkgs.rubyfmt}/bin/rubyfmt";
        };
      }
    ];
  };
}
