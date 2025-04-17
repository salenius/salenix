# Tämän funktion tarkoitus on auttaa
# viemään samat keybindigit Vimiin
# ja Emacsiin, sekä mahdollisesti muihin
# tekstieditoreihin

# Perusidea
# editor = vim | emacs
# mode = normal | insert | visual
# keybinding = string
# function = string

# type = editor -> mode -> keybinding -> function -> string

# NOTE: Käyin Vimin osalta noremap-funktiota map-funktion
# sijasta, koska funktiot eivät ole lähtökohtaisesti rekursiivisia
# vaan mäppäytyvät toisesta näppäinyhdistelmästä toiseen.

# Jos haluat käyttää Vimissä rekursiivisia keybindingeja, käytä
# toista moduulia

editor: mode: keybinding: function: 

let
   vim-nore-map = md: 
    if md == "normal" then "n" else 
    if md == "insert" then "i" else 
    if md == "visual" then "v" else
    if md == "n" then "n" else
    if md == "i" then "i" else
    if md == "v" then "v" else
    "";
   emacs-map = md: 
    if md == "normal" then "normal" else 
    if md == "insert" then "insert" else 
    if md == "visual" then "visual" else
    if md == "n" then "normal" else
    if md == "i" then "insert" else
    if md == "v" then "visual" else
    "";
 
   edit-in = md: kbd: fn: if
     editor == "vim" then "${vim-nore-map md}noremap ${kbd} ${fn}" else if
     editor == "emacs" then "(define-key ${emacs-map md}-mode-map ${kbd} '${fn})" else
     "";
in
   edit-in mode keybinding function
  
