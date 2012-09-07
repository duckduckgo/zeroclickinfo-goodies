#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'gravatar';
zci is_cached => 1;
ddg_goodie_test(
	[qw(
		DDG::Goodie::Gravatar
		)],
	'gravatar kumimoko.yo@gmail.com' => test_zci('<img src="http://www.gravatar.com/avatar/06ecae11d1c3cea65e3f03245c8a31e4?d=mm" />'),
);

done_testing;
