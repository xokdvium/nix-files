{pkgs, ...}: {
  programs.helix.languages = {
    language-server.taplo = {
      command = "${pkgs.taplo}/bin/taplo";
      args = ["lsp" "stdio"];
    };

    language = [
      {
        name = "toml";
        auto-format = true;
        language-servers = ["taplo" "typos-lsp"];
      }
    ];
  };
}
