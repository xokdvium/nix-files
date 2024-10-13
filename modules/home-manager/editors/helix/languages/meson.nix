{ pkgs, ... }:

let
  inherit (pkgs) lib;
  meson-stdin-fmt = pkgs.writeShellScriptBin "meson-stdin-fmt" ''
    ${lib.getExe pkgs.meson} format /dev/stdin "$@"
  '';
in

{
  programs.helix.languages = {
    language-server.mesonlsp = {
      command = "${pkgs.mesonlsp}/bin/mesonlsp";
      args = [ "--lsp" ];
    };

    language = [
      {
        name = "meson";
        auto-format = true;
        language-servers = [
          "mesonlsp"
          "typos-lsp"
        ];
        formatter = {
          command = "${lib.getExe meson-stdin-fmt}";
        };
      }
    ];
  };
}
