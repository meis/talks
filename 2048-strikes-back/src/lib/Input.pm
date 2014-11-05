package Input;
use 5.012;
use Moo;
use Module::Load;
extends 'Games::2048::Game::Input';

my $class = $ENV{'CLASS'} || 'Solver';
load $class;

my %vecs = ( left => [-1, 0], right => [1, 0], up => [0, -1], down => [0, 1] );

has moves => is => 'rw', default => 0;
has time  => is => 'rw';

my $move_score = 0;
my $solver = $class->new;

sub handle_input {
	my ($self, $app) = @_;

    my @board = $self->parse_board;

    $self->move($solver->best_move(@board));
}

sub parse_board {
    my $self = shift;
    my @board;

    for my $x (0..3) {
        for my $y (0..3) {
            if ( my $tile = $self->_tiles->[$x][$y] ) {
                push @board, log($tile->{value}) / log(2);
            }
            else {
                push @board, 0;
            }
        }
    }

    @board;
}

# disable vector input from the user
sub handle_input_key_vector {}

sub handle_finish { $_[1]->restart }

sub draw_score {
	my $self = shift;

	$self->score_height(2);

    $self->time(time()) unless $self->time;
    my $time = time() - $self->time;

    $self->moves($self->moves+1);
    say "moves: " . $self->moves . " time: " . $time . "s" . "   move_score: " . $move_score;

	$self->next::method;
}

1;
