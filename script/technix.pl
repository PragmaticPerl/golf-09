#!perl -p0
sub r{my@e;$e["@-" % 11].=$& while/[^E]/gs;@e}sub x{s/(?<=[^X]{6}.{5}[^X])[ @]{4,}(?=[^X].{5}[^X]{6})/'@'x length$&/egs}$_="E"x11 .$_."E"x20;s/\n/E/g;x;$_="E"x11 .join("E",r)."E"x20;x;$_=join"E",r;s/E/\n/g