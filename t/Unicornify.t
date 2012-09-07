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
			html => 'bob@bob.com\'s unicorn (<a href="http://unicornify.appspot.com/">Learn more at unicornify.appspot.com</a>):<br />'
			.'<a href="'.unicornify_url(email => 'bob@bob.com', size => 128).'">'
			.'<img src="'.unicornify_url(email=>'bob@bob.com', size => 100).'" style="margin: 10px 0px 10px 20px; border-radius: 8px;" /></a>'));

done_testing;
