# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

## Tämän voi buildaa seuraavalla komennolla:
# sudo nixos-rebuild switch --impure --flake ~/Projects/salenix/nixos/#tommiSetup


{ config, lib, pkgs, ... }:

let
  custom-dw-path = true;
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./audiosetup.nix
      ./skriptit.nix
      ./moduulit/salasana.nix
      #(import "${home-manager}/nixos")
    ];

  # Laitettu siksi, koska äänet eivät tällä hetkellä kuulu
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bluetooth päälle
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "elitebook"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Näillä kahdella pitäisi tapahtua automaattinen WiFi:in yhdistäminen loginin jälkeen
  # idea saatu täältä: https://github.com/NixOS/nixpkgs/issues/227591
  networking.interfaces.wlan0.useDHCP = true;
  networking.wireless.interfaces = ["wlan0"];

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # SSH
  security.pam = {
    sshAgentAuth.enable = true;
    services.login.kwallet.enable = true;
  };
 
  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     keyMap = "fi";
     #useXkbConfig = true; # use xkb.options in tty.
   };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "fi";
    xkbVariant = "winkeys,";
  };
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true; # Laitetaan toistaiseksi näin


  
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.tommi = {
     isNormalUser = true;
     extraGroups = [ 
	"wheel" 
	"audio" 
  "networkmanager"
	#"jackaudio"  # Enable ‘sudo’ for the user.
	];
     packages = with pkgs; [
       tree
       librewolf
       fzf
       zoxide
       eza
     ];
   };

  programs.firefox.enable = true;

  services.pcscd.enable = true;

  # DWM enabloitu, TODO: Siirrä tämä ja Dmenu yms
  # omaan moduuliinsa
  services.xserver.windowManager.dwm.enable = true;
  # Tämä alla oleva on kommentoitu pois ja korvattu
  # override-funktion käytöllä, koska otetaan käyttöön
  # aggregoitu patch, joka on alakansiossa
  #services.xserver.windowManager.dwm.package = (
  #  pkgs.dwm.overrideAttrs {
  #  src = /home/tommi/Projects/dwm2/dwm;
  #  });
  services.xserver.windowManager.dwm.package = if custom-dw-path
                                               then (
    pkgs.dwm.overrideAttrs {
      src = /home/tommi/Projects/dwm;
    })
                                               else pkgs.dwm.override {
    patches = [
      /home/tommi/Projects/salenix/nixos/dwm/dwm-uusi-patch.diff # Aggregaatti patch kaikista, jotka kehitetty dynamic_dwm:n alla, siisti tätä vielä
      #/home/tommi/Projects/salenix/nixos/dwm/01_first_patch.diff
      #/home/tommi/Projects/salenix/nixos/dwm/02_shiftview.diff
    ];
  };


  fonts.packages = with pkgs; [
    noto-fonts-color-emoji
  ];
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     git
     wget
     curl
     home-manager
     vlc
     #emacs
     alsa-utils
     feh # Taustakuvat
     ranger # Konfiguraatiot home-manageriin tulevaisuudessa, nyt tässä toistaiseksi

     starship # Tekee command promptista mukavn näköisen
     nerdfonts # Starshipin prompteista upean näköisiä

     # Leikepöydälle kopiointi
     xclip # X11
     wl-clipboard # Wayland

     qutebrowser # Vaihtoehtoinen selain

     ffmpeg-full

     bemenu # Dmenun vaihtoehto

     # DWM:n käyttöön
     dmenu
     #dwmblocks
     (dwmblocks.override {
        conf = /home/tommi/Projects/salenix/nixos/dwm/blocks.def.h;
      })

     imagemagick # jotta pywal16 toimisi
     picom # Jotta terminaaleista saisi läpinäkyviä
     # Kun launchataan esim. GUI-ohjelmia terminaalista, ohjelmaa pyörittävä terminaali piilotetaan
     # sen ajaksi kunnes ohjelma suljetaan
     devour 

     # Erinomainen kuvakaappaustyökalu. Otetaan käyttöön lisäksi,
     # koska voi testata DWM:llä mäpätä print screen -näppäimen
     # tämän ohjelman käynnistämiseen.
     flameshot

     sshfs

     # Automatisointi
     dunst 
     libnotify
     entr 

     # Musan tekoon
     ardour
     qjackctl
     a2jmidid

  ];

  environment.shells = with pkgs; [

     zsh

  ];

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

