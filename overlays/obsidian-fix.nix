{ ... }:

(_final: prev: {
  obsidian = prev.obsidian.overrideAttrs (
    prevAttrs:
    let
      filename =
        if prev.stdenv.isDarwin then
          "Obsidian-${prevAttrs.version}-universal.dmg"
        else
          "obsidian-${prevAttrs.version}.tar.gz";
    in
    {
      src = prev.fetchurl {
        url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${prevAttrs.version}/${filename}";
        hash =
          if prev.stdenv.isDarwin then
            "sha256-o5ELpG82mJgcd9Pil6A99BPK6Hoa0OKJJkYpyfGJR9I="
          else
            "sha256-ho8E2Iq+s/w8NjmxzZo/y5aj3MNgbyvIGjk3nSKPLDw=";
      };
    }
  );
})
