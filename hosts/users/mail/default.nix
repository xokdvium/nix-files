{
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    ./neomutt.nix
    ./notmuch.nix
    ./thunderbird.nix
    ./accounts
  ];

  programs = {
    msmtp.enable = true;
    mbsync.enable = true;
  };

  services = {
    mbsync =
      let
        postExecScript = pkgs.writeShellScript "mbsync-pre-exec.sh" ''
          ${lib.getExe pkgs.notmuch} new
        '';
      in
      {
        enable = true;
        postExec = "${postExecScript}";
      };
  };

  accounts.email = {
    maildirBasePath = ".mail";
  };

  xokdvium.home.persistence = {
    persist.dirs = [ ".mail" ];
  };
}
