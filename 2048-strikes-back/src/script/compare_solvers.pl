#!/usr/bin/env perl
no warnings;
use strict;
use 5.012;

use FindBin;
use lib "lib";
use Module::Load;
use Benchmark qw(:all) ;

my $compare = {};
my @board = (
    0, 0, 0, 0,
    1, 0, 0, 0,
    1, 0, 0, 0,
    0, 0, 0, 0,
);

for my $class ( @ARGV ) {
    load $class;

    my $solver = $class->new;
    $solver->moves(1000);

    $compare->{$class} = sub { $solver->best_move(@board) }
}


cmpthese( 10, $compare );


