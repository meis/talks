#!/usr/bin/env perl

use strict;
use 5.012;
use List::Util qw/shuffle/;
use Benchmark qw(:all) ;

my $rotation = [
    #left
    [ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 ],
    #right
    [ 3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12 ],
    #up
    [ 0,4,8,12,1,5,9,13,2,6,10,14,3,7,11,15 ],
    #down
    [ 12,8,4,0,13,9,5,1,14,10,6,2,15,11,7,3 ],
];

sub shift_row {
    my ( $self, @tiles ) = @_;

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

sub move_board_original {
    my ( $self, $direction, @board ) = @_;

    my @new;

    my $idx = 0;
    for (0..3) {
        my @r = (
            $rotation->[$direction][$idx++],
            $rotation->[$direction][$idx++],
            $rotation->[$direction][$idx++],
            $rotation->[$direction][$idx++]
        );

        ($new[$r[0]], $new[$r[1]], $new[$r[2]], $new[$r[3]] ) = shift_row($board[$r[0]], $board[$r[1]], $board[$r[2]], $board[$r[3]] );

    }

    return @new;
}

sub move_board_modified {
    my ( $self, $direction, @board ) = @_;

    my @new;
    my ($p0,$p1,$p2,$p3);

    my $r = $rotation->[$direction];
    my $idx = 0;
    for (0..3) {
        $p0 = $r->[$idx++];
        $p1 = $r->[$idx++];
        $p2 = $r->[$idx++];
        $p3 = $r->[$idx++];

        ($new[$p0], $new[$p1], $new[$p2], $new[$p3] ) = shift_row($board[$p0], $board[$p1], $board[$p2], $board[$p3] );

    }

    return @new;
}
my @pos = ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 4);

cmpthese( 99999, {
    original => sub { move_board_original(generate_board()) },
    modified => sub { move_board_modified(generate_board()) },
});

sub generate_board {
  my @shuffled = shuffle(@pos);
  @shuffled[0..16];
}



