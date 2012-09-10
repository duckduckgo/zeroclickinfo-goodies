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
	'unicornify example@example.com' => 
		test_zci('This is a unique unicorn for example@example.com:' . "\n" . 'Learn more at unicornify.appspot.com',
		       header =>  'example@example.com (Unicornify)',	
			html => 'This is a unique unicorn for example@example.com:'
			.'<br /><a href="'.unicornify_url(email => 'example@example.com', size => 128).'">'
			.'<img src="'.unicornify_url(email=>'example@example.com', size => 100).'" style="margin: 10px 0px 10px 20px; border-radius: 8px;" /></a>'
			. '<br /><a href="http://unicornify.appspot.com/">Learn more at unicornify.appspot.com</a>'));

done_testing;
