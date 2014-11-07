#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

use FindBin;
use lib "lib";
use Module::Load;

my $class = $ENV{'CLASS'} || 'Solver';
load $class;
my $g = $class->new();

$g->moves(2000);

$g->best_move(
    0, 0, 0, 0,
    1, 0, 0, 0,
    1, 0, 0, 0,
    0, 0, 0, 0,
);

$g->best_move(
    1, 2, 1, 2,
    2, 1, 2, 1,
    1, 2, 1, 0,
    3, 3, 3, 3,
);

$g->best_move(
    1, 3, 1, 2,
    2, 3, 2, 1,
    1, 2, 1, 2,
    2, 1, 2, 1,
);

$g->best_move(
    0, 0, 0, 0,
    0, 0, 0, 0,
    3, 2, 8, 2,
    1, 3, 6, 4,
);
