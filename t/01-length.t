use strict;
use warnings;
use Test::More;
use Storable;

my $results = retrieve 'golf-09-check.out';

my $min    = 1e9;
my @winner = ('nobody');

for my $script (<script/*.pl>) {
    unless ( defined $results->{$script} ) {
        $script =~ s/script\///;
        diag( sprintf "% 20s: failed tests, skipped", $script );
        next;
    }

    local ( *FILE, $/ );
    open FILE, '<', $script or BAIL_OUT();
    local $_ = <FILE>;
    s/\#! ?\S+\s?// if /^\#!/;
    s/\s*\z//;
    my $length = length($_);
    my $points = $results->{$script};

    $script =~ s/script\///;
    diag( sprintf "% 20s: length=% 3s, penalty=%3d",
        $script, $length, $points );
    pass();

    if ( $min > $length + $points ) {
        @winner = ($script);
        $min    = $length + $points;
    }
    elsif ( $min == $length + $points ) {
        push @winner, $script;
    }
}

diag( "And the oscar goes to " . join ", ", @winner );

done_testing();
