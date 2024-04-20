{ inputs, ... }:
(_final: prev: {
  nixd = inputs.nixd.packages.${prev.system}.nixd.overrideAttrs {
    patches = [
      (prev.fetchpatch {
        name = "nixd-nightly-fix-out-of-bounds-access";
        url = "https://patch-diff.githubusercontent.com/raw/nix-community/nixd/pull/443.patch";
        sha256 = "sha256-JTzIYPwBHV0nULK/JGRA2PT2oWnR77PC4cMgr5kiCKI=";
      })
    ];
  };
})
