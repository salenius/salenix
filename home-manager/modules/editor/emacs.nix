{ lib, ...}:

let

  # --- 

   
  evil-macros = ''

  (defmacro def-avain (nimi moodi)
    "yleistyökalu, jonka avulla käyttäjä voi luoda funktioita, jotka asettavat
    puolestaan pikanäppäinkomennon tietyn tilan funktioille. nimi on funktion nimi,
    jonka makro palauttaa, moodi on puolesta mode, jolle funktio voi luoda näppäinyhdistelmän."
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
    use-package
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
    lsp-mode # LSP serveri
    lsp-haskell # Tätä ei ollut mukana lsp-moden paketissa, ladataan erikseen
    corfu # Autocompletion, company vastaavanlainen

    # Hakee kaikki ympäristömuuttujat Emacsiin
    # ilman tätä aiheuttaa virheviestin aloituksessa
    exec-path-from-shell

    # Testataan tätä vs counsel
    helm

    # tarjoaa funktion, jonka avulla Nixin fetch-funktiot saavat oikean
    # rev/sha:n, kun funktio ajetaan deklaraation kohdalla.
    nix-update

    smartparens # Sulkeiden käyttö
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

    ## How undos are done in the evil-mode 
    undo-system = "undo-redo";

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
        "(server-start)" # mahdollistaa esim. calc-ohjelman käytön ad hocisti
      	''(setq backup-directory-alist '(("." . "${var.varmuuskopio-kansio}")))''
	      # "(global-linum-mode t)" # tämä jätetään pois, koska on ilmeisesti tehoton
        "(load-theme '${var.theme})"
      
      	(comment "kieliasetukset")
     	  ''(set-language-environment "utf-8")''
     	  "(set-default-coding-systems 'utf-8)"
     	  ''(set-locale-environment "fi_fi.utf-8")''
     	  ''(setenv "lang" "en_us.utf-8")''
     	  ''(setenv "lc_all" "en_us.utf-8")''
     	  ''(setenv "lc_ctype" "en_us.utf-8")''

     	  (comment "vim-näppäimet")
     	  "(evil-mode 1)"
        "(evil-set-undo-system '${var.undo-system})"
        evil-macros
	      (evil-n "C-ö" "comment-line")
	      (evil-n "ål" "eval-last-sexp")
	      (evil-n "ål" "eval-last-sexp-and-replace-it-by-result")
	      (evil-n "å tab" "indent-region")
	      (evil-i "C-ö" "evil-normal-state")

     	  ";; m-x"
	      (evil-n "åe" var.m-x-provider)
	      (evil-i "åe" var.m-x-provider)
	      (evil-v "åe" var.m-x-provider)
	      (evil-m "åe" var.m-x-provider)

        ## evil-keybindigeja lisää
        (evil-n "§" "end-of-line")
        (evil-n "gö" "beginning-of-line")
        (evil-n "gä" "end-of-line")
        (evil-n "zj" "evil-scroll-down")
        
        (evil-n "zk" "evil-scroll-up")
        (evil-n "zz" "text-scale-increase")
        (evil-n "zo" "text-scale-decrease")

        (evil-n "ås" "save-buffer")

        # tämä on toistaiseksi kommentoitu,
        # koska counselia ei ole asennettu.
        
        # (evil-n "öb" "counsel-ibuffer")

        # buffereiden valikoimeen counselin sijasta
        # helmin oma versio
       (evil-n "öb" "helm-buffers-list")

        # tämä on ollut aiemmin kill-this-buffer
        # mutta emacsin uuden version myötä tämän
        # käyttö sellaisenaan evil-moden kautta
        # aiheuttaa virheviestin eikä tapa bufferia.
        # yritetään löytää pitkällä aikavälillä toimiva
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

        (evil-n "-" "evil-search-forward")
        (evil-n "_" "evil-search-backward")

        (evil-v "c-ö" "comment-box")

        # ohjelmointi
        "(global-corfu-mode)" # autocompletion globaalisti
        "(corfu-popupinfo-mode)" # kompletionehdotukset popup-valikossa
        "(setq corfu-auto t)"

        # smartparens - sulkeet
        (evil-n "äs" "sp-wrap-round")
        (evil-v "äs" "sp-wrap-round")

        (evil-n "äh" "sp-wrap-square")
        (evil-v "äh" "sp-wrap-square")

        (evil-n "äa" "sp-wrap-curly")
        (evil-v "äa" "sp-wrap-curly")
      ];
    
  };
} 
