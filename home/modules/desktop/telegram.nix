{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    telegram-desktop
  ];

  home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.extraOptions.persistence.enable {
    directories = [
      ".local/share/TelegramDesktop"
    ];
  };
}
