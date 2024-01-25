{pkgs, ...}: {
  programs.helix.languages = {
    language-server.vscode-json-language-server = {
      command = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
      args = ["--stdio"];
    };

    language = [
      {
        name = "json";
        auto-format = true;
        language-servers = ["vscode-json-language-server"];
      }
    ];
  };
}
