{ config, ... }:

let
  address = "serjtsimmerman@gmail.com";
in

{
  accounts.email = {
    accounts = {
      "serjtsimmerman" = {
        flavor = "gmail.com";
        inherit address;
        userName = address;
        realName = "Sergei Zimmerman";

        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          patterns = [ "*" ];
        };

        passwordCommand = "${config.programs.password-store.package}/bin/gopass show ${address}";

        thunderbird.enable = true;
        notmuch = {
          enable = true;
        };
      };
    };
  };
}
