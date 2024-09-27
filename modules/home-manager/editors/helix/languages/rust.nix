{ ... }:
{
  programs.helix.languages = {
    language-server.rust-analyzer = {
      command = "rust-analyzer";
    };

    language = [
      {
        name = "rust";
        language-servers = [
          "rust-analyzer"
          "typos-lsp"
        ];
        formatter = {
          command = "rustfmt";
        };
        auto-format = true;
      }
    ];
  };
}
