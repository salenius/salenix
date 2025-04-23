{ config, lib, pkgs, ... }:

{

  # Emacs calculator easily available. If you use a X11 specific tiling WM, tie this
  # to your calculator key on your keyboard (if you have one there)
  calc = ''devour emacsclient -c -e "(calc)"'';
  
  # Quickly transform (preferably a short video) into a GIF. You can check the vdieo
  # duration with videon-pituus program
  mp4-to-gif = ''ffmpeg -i $1 "$\{1%.mp4\}.gif"'';

  rangr = ''
     ${pkgs.kitty}/bin/kitty -e "ranger"
     '';
  
  # Calcualte the duration of the video; makes an easy pair with mp4-to-gif program
  videon-pituus = ''ffprobe -i $1 -show_entries format=duration -v quiet -of csv="p=0"'';

     # Check which keysym appears in X11 windows
     # when you press a certain button in a keyboard
     # Idea copied from here: https://www.reddit.com/r/suckless/comments/mcvk65/where_do_you_find_the_names_of_the_keybaord_keys/
     # Needs xev as a dependency (through xorg.xev)
  which-keypress-x11 = ''
     ${pkgs.xorg.xev}/bin/xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
     '';
 
}
  |> lib.mapAttrs (name: value: pkgs.writeShellScriptBin name value)
  |> lib.attrValues  
  |> (lst: {environment.systemPackages = lst;})
