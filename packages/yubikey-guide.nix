{
  pkgs,
  glow,
  symlinkJoin,
}:
let
  inherit (pkgs) stdenv lib;

  guide = stdenv.mkDerivation {
    name = "yubikey-guide";

    src = pkgs.fetchFromGitHub {
      owner = "drduh";
      repo = "YubiKey-Guide";
      rev = "c41729520faf06c352510118ec9bb042bf4a40e7";
      sha256 = "sha256-ZgSMNWFtRICcv/BStmFMiXbx4Xa9d4bbhqxSVb8NhJg=";
    };

    nativeBuildInputs = with pkgs; [ pandoc ];

    buildPhase = ''
      pandoc README.md -o README.html
    '';

    installPhase = ''
      mkdir -p "$out/share"
      mkdir -p "$out/bin"
      cp -r README.* media/ contrib/ "$out/share/"
      cp -r switch-to-backup-yubikey "$out/bin/"
    '';

    fixupPhase = ''
      patchShebangs $out/bin/switch-to-backup-yubikey
    '';

    meta = with lib; {
      description = "YubiKey-Guide";
      homepage = "https://github.com/drduh/YubiKey-Guide";
      platforms = platforms.all;
      license = licenses.mit;
    };
  };

  script = pkgs.writeShellScriptBin "view-yubikey-guide" ''
    usage() {
      echo "Usage: $(basename "$0") [-c]"
    }

    USE_GLOW=false
    while getopts "c" options; do
      case "$options" in
        c)
          USE_GLOW=true
          ;;
        *)
          usage
          ;;
      esac
    done

    viewer="$(type -P xdg-open || true)"
    if [ -z "$viewer" ] || $USE_GLOW; then
      viewer="${glow}/bin/glow -p"
    fi
    exec $viewer "${guide}/share/README.md"
  '';
in
symlinkJoin {
  name = "yubikey-guide";
  paths = [
    guide
    script
  ];
}
