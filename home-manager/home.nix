{ config, pkgs, lib, ... }@input:

let
  # --- Yhteiset komentojen aliakset shelleille
  shell-alias-set = import ./modules/shell-aliases.nix;
  # --- Yhteiset rc-tiedostojen komennot (.bashrc, .zshrc jne)
  shell-init-rc-common = sh: ''
      eval "$(zoxide init ${sh})"
       eval "$(direnv hook ${sh})"
   '';
  tmux-enabled = true;
  shell-session-variables = {
    EDITOR = "emacs";
  };

  # -- Taustakuvat
  avaruus = "wp-galaxy.jpg";
  taustakuva = avaruus;
in

{

  imports = [
     ./modules/starship.nix
     ./modules/editor/emacs.nix
     ./modules/tmux.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tommi";
  home.homeDirectory = "/home/tommi";

  home.sessionPath = [
    "/home/tommi/skriptit"
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.eza
    pkgs.groff
    pkgs.tmux
    pkgs.bat
    pkgs.hwinfo # Erinomainen hardwaren/laitteiden tietojen tsekkaukseen
    pkgs.nil # Nix language server
    pkgs.dysk # Parempi df ohjelma talletustilan käytön tarkasteluun
  ] ++ (if tmux-enabled then [
   pkgs.zsh-prezto # Automaattinen tmux-launch 

  ] else []);
    
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      #"steam"
      #"steam-run"
      #"steam-original"
      "dropbox"
    ];

  # Dropbox tulee asettaa manuaalisesti päälle, koska
  # muuten pienessä laitteessa (virtuaalikone yms)
  # tallennustila saattaa täyttyä nopeasti
  services = {

    dropbox.enable = true;

    dunst = {
      enable = true;
      settings = {
        global = {
          width = 300;
          height = 600;
          offset = "30x50";
          origin = "top-right";
          transparency = 10;
          frame_color = "#eceff1";
          font = "Jet Brains Mono 14";
        };

        urgency_normal = {
          background = "#37474f";
          foreground = "#eceff1";
          timeout = 10;
        };

      };
    };
  };

  programs = {

    bash = {
      enable = true;
      bashrcExtra = shell-init-rc-common "bash";
      shellAliases = shell-alias-set;
      sessionVariables = shell-session-variables; 
    };

    zsh = {
      enable = true;
      initExtra = shell-init-rc-common "zsh";
      shellAliases = shell-alias-set;
      autosuggestion = {
         enable = true;
       };
      sessionVariables = shell-session-variables;
      prezto = {
        enable = true;
        tmux.autoStartLocal = if tmux-enabled then true else null;
      };
    };


    # Työkalu, joka toimii kuin grep, mutta ilmeisesti tehokkaammin
    # ja pystyy katsomaan kaikkia kansion tiedostoja eikä vain yhtä
    # tiedostoa kerrallaan.
    ripgrep.enable = true;


    # Alacritty asetukset kopioitu Eric Murphy (Youtubettaja) esimerkistä
    alacritty = {
      enable = true;
      settings = {
         window = {
           padding = { x = 5; y = 5; };
           class = {
             instance = "Alacritty";
             general = "Alacritty";
           };
           opacity = 0.75; # 0-1 välillä
         };
         scrolling = {
           history = 10000;
           multiplier = 3; # Kuinka monta riviä yksi skrollaus etenee
         };
         font = {
           size = 10.0;
           normal = {
             family = "JetBrainsMono NFM";
             style = "Regular";
           };
         };
      };
    };

    emacs.package = pkgs.emacs-gtk;

    git = {
      enable = true;
      userName = "salenius";
      userEmail = "tommisalenius@gmail.com";
      aliases = {
        s = "status";
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };


  };
     
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # ''; 

    # Xprofiilissa tehdään seuraavat asiat:
    # - monitorit laitetaan järjestykseen se. Lenovon näyttö on 1., Dell 2. ja läppäri 3:na
    # - dunst-daemoni käynnistetään, jotta notifikaatiot saadaan
    # - picom käynnistetään, jotta kaikki X11:n efektit saadaan renderöityä
    # - taustakuva ladataan (tähän pitää miettiä jokin dynaamisempi ratkaisu)
    # - dwmblockseihin perustuvan statusbarin käynnistys taustalla
    # - Emacs-client käynnistetään, jotta Emacsin ad hoc -ikkunanavaamiset ovat nopeampia
    # - pywallilla saadaan taustakuvasta DWM:n teemavärit, jotka ladataan .Xresources-tiedostoon, kun vanha poistetaan tieltä
    ".xprofile" = {
      text = ''
      xrandr --output eDP-1 --auto --output DP-1 --primary --left-of DP-2 --output DP-2 --left-of  eDP-1
      dunst &
      picom &
      feh --bg-scale --scale-down ${config.home.homeDirectory}/Kuvat/taustakuvat/${taustakuva}
      dwmblocks &
      emacsclient --daemon &
      ${pkgs.pywal16}/bin/wal -i ${config.home.homeDirectory}/Kuvat/taustakuvat/${taustakuva} &&
      rm ${config.home.homeDirectory}/.Xresources && cp ${config.home.homeDirectory}/.cache/wal/colors.Xresources ${config.home.homeDirectory}/.Xresources
      '';
      executable = false;
    };

    ".gnupg/gpg-agent.conf" = {
      text = ''
      pinentry-program /run/current-system/sw/bin/pinentry
      '';

      executable = false;
    };
    
    
    "fzfub" = {
      text = ''
      #!/bin/sh

      case "$(uname -a)" in
           *Darwin*) UEBERZUG_TMP_DIR="$TMPDIR" ;;
           *) UEBERZUG_TMP_DIR="/tmp" ;;
      esac

      cleanup() {
      ${pkgs.ueberzugpp}/bin/ueberzugpp cmd -s "$SOCKET" -a exit
      }
      trap cleanup HUP INT QUIT TERM EXIT

      UB_PID_FILE="$UEBERZUG_TMP_DIR/.$(uuidgen)"
      ${pkgs.ueberzugpp}/bin/ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file "$UB_PID_FILE"
      UB_PID=$(cat "$UB_PID_FILE")

      export SOCKET="$UEBERZUG_TMP_DIR"/ueberzugpp-"$UB_PID".socket

      # run fzf with preview
      fzf --reverse --preview="${pkgs.ueberzugpp}/bin/ueberzugpp cmd -s $SOCKET -i fzfpreview -a add \
                            -x \$FZF_PREVIEW_LEFT -y \$FZF_PREVIEW_TOP \
                            --max-width \$FZF_PREVIEW_COLUMNS --max-height \$FZF_PREVIEW_LINES \
                            -f {}"

      ${pkgs.ueberzugpp}/bin/ueberzugpp cmd -s "$SOCKET" -a exit

      '';
      executable = true;
    };

    "vaihda-taustakuva" = {
      text=''
      ${pkgs.pywal16}/bin/wal -i ${config.home.homeDirectory}/Kuvat/taustakuvat/"$1" &&
      rm ${config.home.homeDirectory}/.Xresources && cp ${config.home.homeDirectory}/.cache/wal/colors.Xresources ${config.home.homeDirectory}/.Xresources
      '';
      executable = true;
    };

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tommi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacs";
    # NOTE: Ei riitä tekemään Alacrittystä oletusterminaalia, piti säätää manuaalisesti vielä koneella
    TERMINAL = "alacritty"; 
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
