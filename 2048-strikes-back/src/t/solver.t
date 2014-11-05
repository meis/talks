use Test::More;
use Data::Dumper;
use v5.10;

my $class = $ENV{'CLASS'} || 'Solver';

require_ok( $class );
ok ( my $game = $class->new, "Instance Solver" );

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
subtest 'Shift row' => sub {
    my @b1 = qw/0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/;
    my @b2 = qw/0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0/;
    my @b3 = qw/0 0 0 1 2 0 3 0 0 0 0 0 0 0 0 0/;
    my @b4 = qw/1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8/;
    my @b5 = qw/0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0/;

    ok( $game->same_board(@b1, @b1), 'Same board');
    ok( $game->same_board(@b1, @b5), 'Same board');
    ok( !$game->same_board(@b1, @b2), 'Not Same board');
    ok( !$game->same_board(@b2, @b1), 'Not Same board');
    ok( !$game->same_board(@b2, @b4), 'Not Same board');
    ok( !$game->same_board(@b3, @b2), 'Not Same board');
};

done_testing()
