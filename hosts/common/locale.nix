{lib, ...}: {
  time.timeZone = lib.mkDefault "Europe/Moscow";

  i18n = {
    defaultLocale = lib.mkDefault "en_GB.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = lib.mkDefault "en_GB.UTF-8";
      LC_IDENTIFICATION = lib.mkDefault "en_GB.UTF-8";
      LC_MEASUREMENT = lib.mkDefault "en_GB.UTF-8";
      LC_MONETARY = lib.mkDefault "en_GB.UTF-8";
      LC_NAME = lib.mkDefault "en_GB.UTF-8";
      LC_NUMERIC = lib.mkDefault "en_GB.UTF-8";
      LC_PAPER = lib.mkDefault "en_GB.UTF-8";
      LC_TELEPHONE = lib.mkDefault "ru_GB.UTF-8";
      LC_TIME = lib.mkDefault "en_GB.UTF-8";
    };

    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
    ];
  };
}
