#!perl -p0
sub z:lvalue{substr$_,$a+pos()-1,1}while(/X/g){for$a(-12..-10,-1,1,10..12){z&&z=~s/ /*/}}s/(   ) /$1@/g;{s/(( .{10}){3}) /$1@/sgc&&redo}
