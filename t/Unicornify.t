#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Unicornify::URL;


zci answer_type => 'unicornify';
zci is_cached => 1;
ddg_goodie_test(
	[qw(
		DDG::Goodie::Unicornify
		)],
	'unicornify bob@bob.com' => 
		test_zci('bob@bob.com\'s unicorn:', 
			html => '<br /><a href="'
			.unicornify_url(email => 'kumimoko.yo@gmail.com', size => 128)
			.'"><img src="'
			.unicornify_url(email=>'kumimoko.yo@gmail.com', size => 100)
			.'" /></a><br /><a href="http://unicornify.appspot.com/">Learn more at unicornify.appspot.com</a>'));

done_testing;
