{
  pkgs,
  lint-nix,
}:
lint-nix.lib.lint-nix rec {
  inherit pkgs;
  src = ./.;

  linters = {
    ruff = {
      ext = ".py";
      cmd = "${pkgs.ruff}/bin/ruff $filename";
    };
  };

  formatters = {
    clang-format = {
      ext = [".c" ".cpp" ".h" ".hpp" ".cc"];
      cmd = "${pkgs.clang-tools}/bin/clang-format";
      stdin = true;
    };

    black = {
      ext = ".py";
      cmd = "${pkgs.black}/bin/black $filename";
    };

    yamlfmt = {
      ext = [".yaml" ".yml" ".clang-format" ".clang-tidy"];
      cmd = "${pkgs.yamlfmt}/bin/yamlfmt $filename";
    };

    alejandra = {
      ext = ".nix";
      cmd = "${pkgs.alejandra}/bin/alejandra";
      stdin = true;
    };

    rustfmt = {
      ext = ".rs";
      cmd = "${pkgs.rustfmt}/bin/rustfmt $filename";
    };

    rubyfmt = {
      ext = [".rb"];
      cmd = "${pkgs.rubyfmt}/bin/rubyfmt $filename --in-place";
    };
  };
}
