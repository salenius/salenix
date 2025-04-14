{ config, lib, pkgs, ... }:

{

  musnix = {
    enable = true;

    # VM-kone spesifi! Tämä tulisi vaihtaa
    # tarvittaessa kun kone vaihtuu
    soundcardPciId = "00:05.0";

    # Jos musiikintuotannossa havaitaan ärsyttävää
    # lagia, vaihda tämä tarvittaessa trueksi.
    # Ongelmana, että jos tämä on true, niin
    # alkaa kääntää kerneliä, mikä on tuhottoamsti
    # aikaa vievä prosessi.
    kernel.realtime = false;
    
    rtirq.enable = true;
  };

  users.users.tommi.extraGroups = [ "jackaudio" ];

  # Enable sound.
  hardware.pulseaudio.enable = false; # Virheviesti jos true
  # # rtkit is optional but recommended
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

}
