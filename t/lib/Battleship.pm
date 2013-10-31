package Battleship;
use strict;
use warnings;
use Carp;

my @ships = ( [ 1, 4 ], [ 2, 3 ], [ 3, 2 ], [ 4, 1 ] );
my $max_attempts = 100;

sub new {
    my $class = shift;
    my $field = ' ' x 100;

    my $attempt = 1;
    my $visual  = 0;
    for my $ship (@ships) {
        for my $n ( 1 .. $ship->[0] ) {
            my $vertical = int( rand 2 );
            my $x        = int( rand 10 - ( !$vertical ) * $ship->[1] );
            my $y        = int( rand 10 - $vertical * $ship->[1] );

            my $bx = $x == 0 ? $x : $x - 1;
            my $by = $y == 0 ? $y : $y - 1;
            my $ex = $x + ( !$vertical ) * $ship->[1];
            my $ey = $y + $vertical * $ship->[1];
            $ex++ if $ex < 9;
            $ey++ if $ey < 9;

            my $box = '';
            for ( 0 .. ( $ey - $by ) ) {
                $box .= substr $field, ( $by + $_ ) . $bx, $ex - $bx + 1;
            }
            redo if $box =~ /\d/ && $attempt++ < $max_attempts;
            croak "failed to generate BattleField within $attempt attempts\n"
              if $attempt > $max_attempts;
            $attempt = 1;

            for ( 1 .. $ship->[1] ) {
                substr $field,
                  ( $y + $vertical * $_ ) . ( $x + ( !$vertical ) * $_ ), 1,
                  $visual;
            }
            $visual++;
        }
    }

    bless { field => $field }, $class;
}

sub field {
    my $self = shift;
    $self->{field} = shift if @_;
    $self->{field};
}

sub print_field {
    my $self = shift;
    print " .-a-b-c-d-e-f-g-h-i-j-.\n";
    for my $y ( 1 .. 10 ) {
        printf "%2d %s |\n", $y,
          join( ' ', split '', substr( $self->{field}, ( $y - 1 ) * 10, 10 ) ),
          ;
    }
    print " `---------------------'\n";
}

sub raw_field {
    my $self = shift;
    join "\n", ( $self->{field} =~ /.{10}/g );
}

sub blind_fire {
    my ( $self, $rate ) = @_;
    $rate ||= 30;
    croak "invalid rate of fire" if $rate >= 96 || $rate <= 0;
    my @attempts = ( 0 .. 99 );

    while ( $rate-- > 0 ) {
        croak "Ouch, no more attempts. Rate is $rate" unless @attempts;
        my ($i) = splice @attempts, int( rand @attempts ), 1;
        my $f = substr $self->{field}, $i, 1;
        redo if $f =~ /[0X\*]/;

        if ( $f =~ /\d/ ) {
            my ($c) = $self->{field} =~ s/$f/X/g;
            $rate -= $c - 1;
        }
        else {
            substr $self->{field}, $i, 1, '*';
        }
    }
    $self;
}

1;
