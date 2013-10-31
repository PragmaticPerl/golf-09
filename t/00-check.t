use strict;
use warnings;
use Test::More;
use IPC::Run qw( start finish );
use Storable;
use lib 't/lib';
use Battleship;

sub match_pos {
    my ( $field, $symbol ) = @_;
    my $pos = 0;
    my @res = ();
    while ( ( my $i = index( $field, $symbol, $pos ) ) != -1 ) {
        push @res, $i;
        $pos = $i + 1;
    }
    return @res;
}

sub data {

    my @data;

    for ( 1 .. 3 ) {

        my $bs = Battleship->new;
        $bs->print_field;
        my $bak = $bs->field;

        for my $rate ( 60, 50, 40, 30 ) {
            $bs->field($bak);
            $bs->blind_fire($rate)->print_field;

            my $f = $bs->raw_field;
            my @res = match_pos( $f, '0' );
            $f =~ s/\d/ /g;
            push @data, [ $f, \@res, "BattleField: $_, Rate: $rate" ];
        }
    }

    return @data;
}

sub run_test {
    my ( $script, $data ) = @_;
    my ( $in, $out );
    my $h = start [ 'perl', $script ], \$in, \$out;
    $in .= $data->[0];
    finish($h);
    my @pos = match_pos( $out, '@' );
    my @win = grep {
        $a = $_;
        grep { $a eq $_ } @{ $data->[1] }
    } @pos;
    my $miss = @pos - @win;
    ok( @win > 0,
        $data->[2] . ", Misses: $miss. Tried to injure battleship..." );
    return ( @win ? 1 : 0, $miss );
}

my %results;
my @data = data;

for my $script (<script/*.pl>) {
    diag("Testing $script");
    my ( $miss, $loose ) = ( 0, 0 );

    for my $data (@data) {
        my @r = run_test( $script, $data );
        $loose = 1 unless $r[0];
        $miss += $r[1];
    }

    $miss = int( 10 * $miss / @data );
    $results{$script} = $loose ? undef : $miss;
    diag( $loose ? "Not ok" : "Ok. Penalty: $miss points" );
}

store \%results, 'golf-09-check.out';

done_testing;
