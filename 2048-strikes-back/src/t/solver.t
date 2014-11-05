use Test::More;
use Data::Dumper;
use v5.10;

say shift;

BEGIN { use_ok( 'Solver' ); }
require_ok( 'Solver' );
ok ( my $game = Solver->new, "new object" );

my ($left,$right,$up,$down) = (0,1,2,3);

subtest 'Shift row' => sub {
    my @row;
    ok( join('', $game->shift_row(1,1,0,0)) eq '2000', '1100 -> 2000');
    ok( join('', $game->shift_row(0,0,0,1)) eq '1000', '0001 -> 1000');
    ok( join('', $game->shift_row(0,3,0,3)) eq '4000', '0303 -> 4000');
    ok( join('', $game->shift_row(3,2,0,2)) eq '3300', '3202 -> 3300');
    ok( join('', $game->shift_row(0,0,0,0)) eq '0000', '0000 -> 0000');
    ok( join('', $game->shift_row(1,0,0,0)) eq '1000', '1000 -> 1000');
    ok( join('', $game->shift_row(1,2,3,4)) eq '1234', '1234 -> 1234');
    ok( join('', $game->shift_row(1,2,1,2)) eq '1212', '1212 -> 1212');
    ok( join('', $game->shift_row(1,2,2,1)) eq '1310', '1221 -> 1310');
};

subtest 'Move board' => sub {
    my @input;
    my @expected;

    @input = qw/
        0 0 0 0
        0 1 0 0
        0 0 0 0
        0 0 0 0
    /;
    @expected = qw/
        0 0 0 0
        1 0 0 0
        0 0 0 0
        0 0 0 0
    /;
    ok( join('',$game->move_board($left,@input)) eq join('',@expected), 'Move left' );

    @input = qw/
        0 0 0 0
        1 1 0 0
        0 0 0 0
        0 0 0 0
    /;
    @expected = qw/
        0 0 0 0
        2 0 0 0
        0 0 0 0
        0 0 0 0
    /;
    ok( join('',$game->move_board($left,@input)) eq join('',@expected), 'Move left' );

    @input = qw/
        0 0 0 0
        1 1 0 0
        0 0 0 0
        0 0 0 0
    /;
    @expected = qw/
        1 1 0 0
        0 0 0 0
        0 0 0 0
        0 0 0 0
    /;
    ok( join('',$game->move_board($up,@input)) eq join('',@expected), 'Move up' );

    @input = qw/
        0 0 0 0
        1 0 0 0
        1 0 0 0
        0 0 0 0
    /;
    @expected = qw/
        2 0 0 0
        0 0 0 0
        0 0 0 0
        0 0 0 0
    /;
    ok( join('',$game->move_board($up,@input)) eq join('',@expected), 'Move up' );

    @input = qw/
        0 0 0 0
        1 0 0 0
        1 0 0 0
        0 0 0 0
    /;
    @expected = qw/
        0 0 0 0
        0 0 0 0
        0 0 0 0
        2 0 0 0
    /;
    ok( join('',$game->move_board($down,@input)) eq join('',@expected), 'Move up' );

    @input = qw/
        0 0 0 0
        1 0 0 0
        1 0 0 0
        0 0 0 0
    /;
    @expected = qw/
        0 0 0 0
        0 0 0 1
        0 0 0 1
        0 0 0 0
    /;
    ok( join('',$game->move_board($right,@input)) eq join('',@expected), 'Move up' );

    @input = qw/
        0 0 0 0
        1 0 0 0
        1 0 0 0
        0 0 0 0
    /;
    @expected = qw/
        0 0 0 0
        1 0 0 0
        1 0 0 0
        0 0 0 0
    /;
    ok( join('',$game->move_board($left,@input)) eq join('',@expected), 'Move up' );
};

done_testing()
