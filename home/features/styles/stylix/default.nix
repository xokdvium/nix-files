{
  pkgs,
  config,
  ...
}: let
  mkStylixFont = profile: {
    inherit (profile) package;
    name = profile.family;
  };
in {
  stylix = {
    image = pkgs.fetchurl {
      url = "https://i.redd.it/l9b4injyhc381.png";
      sha256 = "sha256-EBknngbhEYqimfhROG7cGzvixihJe+703d1CR19iqN8=";
    };

    fonts = with config.fontProfiles; {
      serif = mkStylixFont regular;
      sansSerif = mkStylixFont regular;
      monospace = mkStylixFont monospace;
      emoji = mkStylixFont emoji;

      sizes = {
        terminal = 10;
        desktop = 10;
        popups = 10;
        applications = 10;
      };
    };

    autoEnable = false;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/twilight.yaml";
  };
}
