#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

use FindBin;
use lib "lib";
use Games::2048;
use Input;
Games::2048->new(
	game_class => "Input",
	no_save_game => 1,
	no_restore_game => 1,
	no_animations => 1,
)->run;
