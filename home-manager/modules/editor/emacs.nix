{ lib, ...}:

let

  # --- 

   
  evil-macros = ''

  (defmacro def-avain (nimi moodi)
    "Yleistyökalu, jonka avulla käyttäjä voi luoda funktioita, jotka asettavat
    puolestaan pikanäppäinkomennon tietyn tilan funktioille. NIMI on funktion nimi,
    jonka makro palauttaa, MOODI on puolesta mode, jolle funktio voi luoda näppäinyhdistelmän."
    `(defun ,nimi (key func)
	 (define-key ,moodi (kbd key) func)))

  (defmacro luo-avain (moodi key func)
    `(add-hook (quote ,(intern (concat (symbol-name moodi) "-hook")))
		   (lambda () (evil-define-key 'normal ,(intern (concat (symbol-name moodi) "-map")) (kbd ,key) (quote ,func)))))


  (defmacro kirjoita (merkki)
    `(lambda ()
	 (interactive)(insert ,merkki)))

  (def-avain evil-ins evil-insert-state-map)
  (def-avain evil-n evil-normal-state-map)
  (def-avain evil-i evil-insert-state-map)
  (def-avain evil-m evil-motion-state-map)
  (def-avain evil-v evil-visual-state-map)
  (def-avain company-a company-active-map)
  '';

  # ----- Emacs-funktiot -----
  # --------------------------
  setq = var: val: "(setq ${var} ${val})";
  add-hook = mode: hook: "(add-hook '${mode}-hook '${hook})";
  evil-func = mode: kbd: func: ''(evil-${mode} ${teksti kbd} '${func})'';
  evil-n = evil-func "n";
  evil-i = evil-func "i";
  evil-v = evil-func "v";
  evil-ins = evil-func "ins";
  evil-m = evil-func "m";
  
  # Muuta Emacs-funktionaalisuutta
  comment = txt: ";; ${txt}";
  teksti = txt: "\"${txt}\"";

  # ----- Custom settings here
  packages = epkgs: with epkgs; [
    # Välttämätön, jotta vim-näppäimet
    evil

   # Tällä ikkunoiden välissä pomppailu
    ace-window

    # Teemat
    dracula-theme
    zenburn-theme

   # Kaikki halutut ohjelmointikielet tähän
   haskell-mode
   nix-mode

   # Hakee kaikki ympäristömuuttujat Emacsiin
   # ilman tätä aiheuttaa virheviestin aloituksessa
   exec-path-from-shell

   # Testataan tätä vs counsel
   helm
  ];


  var = rec {

    # Muita teemoja tällä hetkellä zenburn
    theme = "dracula";


	  standard-indent-string = toString standard-indent;
  	startup-not-showing = if startup-screen-off then "t" else "nil";
 	  toolbar-number = if toolbar-off then "-1" else "1";

	  # ---- Set these
	  standard-indent = 2; 
 	  scratch-viesti = teksti "Hei NixOS-käyttäjä!";
 	  toolbar-off = true;
 	  startup-screen-off = true;

 	  varmuuskopio-kansio = "~/.emacs.d/backup";
	  m-x-provider = "helm-M-x";
  };
in 
{
  programs.emacs = {
      enable = true;
      extraPackages = packages;
      extraConfig = builtins.concatStringsSep "\n\n" [
      	(setq "standard-ident" var.standard-indent-string)
      	"(tool-bar-mode ${var.toolbar-number})"
      	(setq "inhibit-startup-message" var.startup-not-showing)
 	      (setq "initial-scratch-message" var.scratch-viesti)
      	"(exec-path-from-shell-initialize)"
        "(server-start)" # Mahdollistaa esim. calc-ohjelman käytön ad hocisti
      	''(setq backup-directory-alist '(("." . "${var.varmuuskopio-kansio}")))''
	      # "(global-linum-mode t)" # Tämä jätetään pois, koska on ilmeisesti tehoton
        "(load-theme '${var.theme})"
      
      	(comment "Kieliasetukset")
     	  ''(set-language-environment "UTF-8")''
     	  "(set-default-coding-systems 'utf-8)"
     	  ''(set-locale-environment "fi_FI.UTF-8")''
     	  ''(setenv "LANG" "en_US.UTF-8")''
     	  ''(setenv "LC_ALL" "en_US.UTF-8")''
     	  ''(setenv "LC_CTYPE" "en_US.UTF-8")''

     	  (comment "Vim-näppäimet")
     	  "(evil-mode 1)"
        evil-macros
	      (evil-n "C-ö" "comment-line")
	      (evil-n "ål" "eval-last-sexp")
	      (evil-n "åL" "eval-last-sexp-and-replace-it-by-result")
	      (evil-n "å TAB" "indent-region")
	      (evil-i "C-ö" "evil-normal-state")

     	  ";; M-x"
	      (evil-n "åe" var.m-x-provider)
	      (evil-i "åe" var.m-x-provider)
	      (evil-v "åe" var.m-x-provider)
	      (evil-m "åe" var.m-x-provider)

        ## Evil-keybindigeja lisää
        (evil-n "§" "end-of-line")
        (evil-n "zj" "evil-scroll-down")
        
        (evil-n "zk" "evil-scroll-up")
        (evil-n "zz" "text-scale-increase")
        (evil-n "zo" "text-scale-decrease")

        (evil-n "ås" "save-buffer")

        # Tämä on toistaiseksi kommentoitu,
        # koska counselia ei ole asennettu.
        
        # (evil-n "öb" "counsel-ibuffer")

        # Buffereiden valikoimeen counselin sijasta
        # helmin oma versio
        (evil-n "öb" "helm-buffers-list")

        # Tämä on ollut aiemmin kill-this-buffer
        # mutta Emacsin uuden version myötä tämän
        # käyttö sellaisenaan evil-moden kautta
        # aiheuttaa virheviestin eikä tapa bufferia.
        # Yritetään löytää pitkällä aikavälillä toimiva
        # ratkaisu, missä bufferia ei tarvitse spesifioida.
        (evil-n "öä" "kill-buffer")

        (evil-n "öd" "dired")
        (evil-n "gf" "helm-find-files")
        (evil-n "ää" "evil-execute-macro")

        (evil-n "öwh" "split-window-right")
        (evil-n "öwv" "split-window-below")
        (evil-n "ökt" "delete-window")
        (evil-n "öka" "delete-other-windows")
        (evil-n "öö" "ace-window")

        (evil-n "åc" "capitalize-word")

        (evil-v "C-ö" "comment-box")
     

      ];
    
  };
} 
