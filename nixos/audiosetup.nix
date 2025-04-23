{ config, lib, pkgs, ... }:

{

  musnix = {
    enable = true;

    # Voi katsoa seuraavasti (Chris McDonoughille creditit):
    # $ nix-shell -p pciutils
    # $ lspci | grep -i audio
    soundcardPciId = "00:1f.3";

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
    audio.enable = true; # Ei ollut virtuaalikoneessa, kokeillaan saako tällä äänet
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

   systemd.user.services.pipewire-pulse.path = [ pkgs.pulseaudio ];

}
