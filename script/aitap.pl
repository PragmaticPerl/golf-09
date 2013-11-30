#!perl -p0
sub z:lvalue{substr$_,$a+($;=pos()?pos()-1:$;),1}while(/X/g){for
$a(-12,-11,-10,-1,1,10,11,12){z&&z=~s/ /*/}}s/(   ) /$1@/g;
1 while s/(( .{10}){3}) /$1@/sgc;
