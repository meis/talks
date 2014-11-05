#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

use FindBin;
use lib "lib";
use Solver;
use Data::Dumper;

my $g = Solver->new();

say Dumper($g->best_move(
    0, 0, 0, 0,
    1, 0, 0, 0,
    1, 0, 0, 0,
    0, 0, 0, 0,
));

say Dumper($g->best_move(
    1, 2, 1, 2,
    2, 1, 2, 1,
    1, 2, 1, 0,
    3, 3, 3, 3,
));

say Dumper($g->best_move(
    1, 3, 1, 2,
    2, 3, 2, 1,
    1, 2, 1, 2,
    2, 1, 2, 1,
));
say Dumper($g->best_move(
    0, 0, 0, 0,
    0, 0, 0, 0,
    3, 2, 8, 2,
    1, 3, 6, 4,
));

