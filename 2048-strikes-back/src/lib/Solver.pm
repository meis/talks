package Solver;
use v5.12;
use Moose;
use strict;
use Parallel::ForkManager;

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

my $_moves = 2000;

sub moves {
    $_moves = $_[1];
}

sub new {
    return bless {}, shift;
}

sub best_move {
    my ($self, @board) = @_;

    my %scores = ();

    my $pm = Parallel::ForkManager->new(8);

    $pm->run_on_finish (
        sub {
            my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data_structure_reference) = @_;

            if (defined($data_structure_reference)) {
              $scores{${$data_structure_reference}->[0]} += ${$data_structure_reference}->[1];
            }
        }
    );

    for (1..2) {
        for my $direction (0,1,2,3) {
            my @moved_board = $self->move_board($direction, @board);

            if ( grep { $board[$_] != $moved_board[$_] } 0..15 ) {
                $pm->start and next;

                srand(time + $direction);
                my $score;

                for (1..($_moves/2)) {
                    $score += $self->play_random_game(@moved_board);
                }

                $pm->finish(0, \[$direction, $score]);
            }
        }
    }

    $pm->wait_all_children;
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
    my @free_cells;

    while ( $free ) {
        @free_cells = grep { !$board[$_] } 0..@board -1;
        # 90% of values are "2", 10% are "4"
        #my @new_board = @board;
        $board[@free_cells[rand @free_cells]] = int(1.1 + rand(1));

        next unless $free =  @free_cells -1;

        my @new_board = @board;

        LOOP: while ( 1 ) {
            @new_board = $self->move_board( int(rand(4)), @board);

            for my $i (0..15) {
                last LOOP if $new_board[$i] != $board[$i];
            }
        }

        @board =  @new_board;
        $score++;
    }

    return $score;
}

sub move_board {
    my ( $self, $direction, @board ) = @_;

    my ($p0,$p1,$p2,$p3);
    my $idx = 0;

    for (0..3) {
        $p0 = $rotation->[$direction][$idx++];
        $p1 = $rotation->[$direction][$idx++];
        $p2 = $rotation->[$direction][$idx++];
        $p3 = $rotation->[$direction][$idx++];

        my @tiles = grep {$_} ($board[$p0], $board[$p1], $board[$p2], $board[$p3] );

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

        $board[$p0] = $tiles[0] || 0;
        $board[$p1] = $tiles[1] || 0;
        $board[$p2] = $tiles[2] || 0;
        $board[$p3] = $tiles[3] || 0;

    }

    return @board;
}

1;
