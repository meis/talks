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

$g->best_move(
    0, 0, 0, 0,
    1, 0, 0, 0,
    1, 0, 0, 0,
    0, 0, 0, 0,
);
