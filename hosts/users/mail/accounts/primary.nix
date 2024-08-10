{ config, ... }:

let
  address = "sergei.s.zimmerman@gmail.com";
in

{
  accounts.email = {
    accounts = {
      "sergei.s.zimmerman" = {
        primary = true;
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

        neomutt = {
          enable = true;
          showDefaultMailbox = false;
          extraConfig = ''
            set virtual_spoolfile = yes
          '';
        };

        thunderbird.enable = true;

        notmuch = {
          enable = true;
          neomutt = {
            enable = true;

            virtualMailboxes = [
              {
                name = "inbox";
                query = "tag:inbox";
              }
              {
                name = "unread";
                query = "tag:unread";
              }
              {
                name = "spam";
                query = "tag:spam";
              }
              {
                name = "sent";
                query = "from:${address}";
              }
            ];
          };
        };
      };
    };
  };
}
