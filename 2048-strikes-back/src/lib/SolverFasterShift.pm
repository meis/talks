package SolverFasterShift;
use v5.12;
use Moose;
use strict;
use List::Util qw(shuffle);

has 'moves'    => ( is => 'rw', default => 2000 );
has 'rotation' => (
    is      => 'ro',
    default => sub {[
        #left
        [ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 ],
        #right
        [ 3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12 ],
        #up
        [ 0,4,8,12,1,5,9,13,2,6,10,14,3,7,11,15 ],
        #down
        [ 12,8,4,0,13,9,5,1,14,10,6,2,15,11,7,3 ],
    ]},
);

sub best_move {
    my ($self, @board) = @_;

    my %scores = ();

    for my $direction (0,1,2,3) {
        my @moved_board = $self->move_board($direction, @board);

        if ( !$self->same_board(@moved_board, @board) ) {
            for (1..$self->moves) {
                $scores{$direction} += $self->play_random_game(@moved_board);
            }
        }
    }

    my $dir = (sort {$scores{$b} <=> $scores{$a}} keys %scores)[0];

    return [-1, 0] if $dir == 0;
    return [ 1, 0] if $dir == 1;
    return [ 0,-1] if $dir == 2;
    return [ 0, 1];
}

sub play_random_game {
    my ( $self, @board ) = @_;

    my $score = 0;

    my $free = 1;
    while ( $free ) {
        ($free, @board) = $self->add_random_tile(@board);

        next unless $free;

        @board = $self->random_player_move(@board);
        $score++;
    }

    return $score;
}

sub add_random_tile {
    my ( $self, @board ) = @_;
    my @free_cells = grep { !$board[$_] } 0..@board -1;
    # 90% of values are "2", 10% are "4"
    #my @new_board = @board;
    $board[@free_cells[rand @free_cells]] = int(1.1 + rand(1));

    return ( @free_cells -1, @board );
}

sub random_player_move {
    my ( $self, @board ) = @_;

    my ( $score, $free );
    my @moves = shuffle(0, 1, 2, 3);
    my @new_board = @board;

    while ( $self->same_board(@new_board, @board) && @moves) {
        @new_board = $self->move_board(pop @moves,@board);
    }

    return @new_board;
}

sub same_board {
    my $self = shift;
    my @b1 = @_[0..15];
    my @b2 = @_[16..31];

    !grep { $b1[$_] != $b2[$_] } 0..@b1-1;
}

sub shift_row {
    shift;
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
    @tiles = grep {$_} @tiles;

    $tiles[0] = 0 unless $tiles[0];
    $tiles[1] = 0 unless $tiles[1];
    $tiles[2] = 0 unless $tiles[2];
    $tiles[3] = 0 unless $tiles[3];

    return @tiles;
}

sub move_board {
    my ( $self, $direction, @board ) = @_;

    my @new;

    my $idx = 0;
    for (0..3) {
        my @r = (
            $self->rotation->[$direction][$idx++],
            $self->rotation->[$direction][$idx++],
            $self->rotation->[$direction][$idx++],
            $self->rotation->[$direction][$idx++]
        );

        ($new[$r[0]], $new[$r[1]], $new[$r[2]], $new[$r[3]] ) = $self->shift_row($board[$r[0]], $board[$r[1]], $board[$r[2]], $board[$r[3]] );

    }

    return @new;
}

sub print_board {
    my $self = shift;

    say join("-", @_[0..3]);
    say join("-", @_[4..7]);
    say join("-", @_[8..11]);
    say join("-", @_[12..15]);
}

1;
