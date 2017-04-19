#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'notepad';
zci is_cached => 0;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Notepad
        )],
        'notepad'   => test_zci( "You can view a notepad on the web", html=> qr/(.*)ddgpad(.*)/ ),
	'editor'   => test_zci( "You can view a notepad on the web", html=> qr/(.*)ddgpad(.*)/ ),
	'jotter'   => test_zci( "You can view a notepad on the web", html=> qr/(.*)ddgpad(.*)/ ),
	'writing space'   => test_zci( "You can view a notepad on the web", html=> qr/(.*)ddgpad(.*)/ ),
	'textarea'   => test_zci( "You can view a notepad on the web", html=> qr/(.*)ddgpad(.*)/ ),
);

done_testing;
