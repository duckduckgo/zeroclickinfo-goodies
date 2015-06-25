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
		       heading =>  'example@example.com (Unicornify)',
			html => 'This is a unique unicorn for example@example.com:'
			.'<br /><a href="'.unicornify_url(email => 'example@example.com', size => 128).'">'
			.'<img src="/iu/?u='.unicornify_url(email=>'example@example.com', size => 100).'" class="zci--unicornify-img" /></a>'
			. 'Learn more at <a href="http://unicornify.appspot.com/">unicornify.appspot.com</a>'));

done_testing;
