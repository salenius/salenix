//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
  /*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
  // Akun käyttö => laajenna tätä skriptillä niin että dynaaminen ikoni akun prosentin mukaan
  {"󰂏 : ", "upower -i $(upower --enumerate) | awk '/percentage/ {print $2}'", 45,          0},
  // Internet-yhteys
  {" : ", "nm-online -q && echo \"󰸞\" || echo \"\"",                     30,             0},
  
  {" : ", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",	30,		0},
  
  {" : ", "date '+%d.%m.%y (%a) %H:%M' ", 					5,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
