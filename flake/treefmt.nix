{
  treefmt = {
    projectRootFile = "flake.nix";
    programs = {
      nixfmt-rfc-style.enable = true;
      yamlfmt.enable = true;
      deadnix.enable = true;
      just.enable = true;
      keep-sorted.enable = true;
      mdformat.enable = true;
    };
  };
}
