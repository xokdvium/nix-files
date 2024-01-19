{lib, ...}: {
  time.timeZone = lib.mkDefault "Europe/Moscow";

  i18n = {
    defaultLocale = lib.mkDefault "en_GB.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
    ];
  };
}
