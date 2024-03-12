_: {
  programs.helix.languages = {
    language = [
      {
        name = "just";
        comment-token = "#";
        file-types = [ "justfile" ];
        indent = {
          tab-width = 2;
          unit = "  ";
        };
        language-servers = [ "typos-lsp" ];
      }
    ];
  };
}
