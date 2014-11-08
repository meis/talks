#!/usr/bin/env perl

use strict;
use 5.012;
use List::Util qw/shuffle/;
use Benchmark qw(:all) ;
use Test::More;

my %methods = (
    modified => sub {
        # Not null tiles, this moves all left
        my @tiles = grep {$_} @_;

        if ( $tiles[0] && $tiles[1] && $tiles[0] == $tiles[1] ) {
            $tiles[0]++;
            delete $tiles[1];
        }

        if ( $tiles[1] && $tiles[2] && $tiles[1] == $tiles[2] ) {
            $tiles[1]++;
            delete $tiles[2];
        }

        if ( $tiles[2] && $tiles[3] && $tiles[2] == $tiles[3] ) {
            $tiles[3]++;
            delete $tiles[2];
        }

        $tiles[0] = 0 unless $tiles[0];
        $tiles[1] = 0 unless $tiles[1];
        $tiles[2] = 0 unless $tiles[2];
        $tiles[3] = 0 unless $tiles[3];

        return @tiles;
    },
    original => sub {
        my ( @tiles ) = @_;

        # Not null tiles, this moves all left
        @tiles = grep {$_} @tiles;
        # Complete void tiles
        $tiles[$_] = 0 for (@tiles..3);

        # Join pairs
        for my $p ( [0,1], [1,2], [2,3] ) {
            next unless $tiles[$p->[0]] && $tiles[$p->[1]];
            if ( $tiles[$p->[0]] == $tiles[$p->[1]] ) {
                $tiles[$p->[0]] += 1;
                $tiles[$p->[1]] = 0;
            }
        }

        # Move null tiles to right and count free cells
        @tiles = grep {$_} @tiles;
        $tiles[$_] = 0 for (@tiles..3);

        return @tiles;
    }
);

for my $method ( qw/original modified/ ) {
    my @row;
    @row = $methods{$method}->(1,1,0,0);
    ok( $row[0] == 2 && $row[1] == 0 && $row[2] == 0 && $row[3] == 0, 'row ok');
    @row = $methods{$method}->(0,0,0,1);
    ok( $row[0] == 1 && $row[1] == 0 && $row[2] == 0 && $row[3] == 0, 'row ok');
    @row = $methods{$method}->(0,3,0,3);
    ok( $row[0] == 4 && $row[1] == 0 && $row[2] == 0 && $row[3] == 0, 'row ok');
    @row = $methods{$method}->(3,2,0,2);
    ok( $row[0] == 3 && $row[1] == 3 && $row[2] == 0 && $row[3] == 0, 'row ok');
}

done_testing;

my @pos = ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 4);
#my @rows = map { generate_row() } (0..1000000);
#
#use Data::Dumper;
#say Dumper(@rows);
#

#while(@rows) {
#    my @shifted = shift_row(shift @rows, shift @rows, shift @rows, shift @rows);
#}
#

cmpthese( 99999, {
    original => sub { $methods{original}->(generate_row()) },
    modified => sub { $methods{modified}->(generate_row()) },
});

sub generate_row {
  my @shuffled = shuffle(@pos);
  @shuffled[0..3];
}



