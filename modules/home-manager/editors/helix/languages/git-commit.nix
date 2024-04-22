_: {
  programs.helix.languages = {
    language = [
      {
        name = "git-commit";
        language-servers = [ "typos-lsp" ];
      }
    ];
  };
}
