{ lib, ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.pulseaudio = {
    enable = lib.mkForce false;
    support32Bit = lib.mkForce false;
  };
}
