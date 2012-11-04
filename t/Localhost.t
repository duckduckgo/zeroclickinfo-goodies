#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'localhost';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Localhost
        )],
        'localhost'   => test_zci( qr/Did you mean to go to(.*)/ ),
        'http://localhost/'   => test_zci( qr/Did you mean to go to(.*)/ ),
	'http://localhost/i/am/a/url'   => test_zci( qr!Did you mean to go to(.*)i/am/a/url(.*)! )
);

done_testing;
