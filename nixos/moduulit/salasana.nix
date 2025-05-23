{ pkgs, lib, config, ... }:

let
  # Muokkaa tätä jos haluat vaihtaa ohjelmaa, joka kysyy salasanan
  # kun käytät passmenua
  pinentry-program = pkgs.pinentry-gtk2;

in 
{
  environment.systemPackages = [
    pkgs.pass
    pkgs.dmenu-wayland # Waylandissa toimiva Dmenu, jotta passmenu toimii siellä
    pkgs.gnupg # GPG-avaimien generointi
    pinentry-program
  ];

  programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pinentry-program;
      enableSSHSupport = true;
    };


}

