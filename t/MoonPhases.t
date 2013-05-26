#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 0;
zci answer_type => 'moonphases';

ddg_goodie_test(
    [qw(
        DDG::Goodie::MoonPhases
    )],
    'moon phase' => test_zci(
    	qr/The current lunar phase is/,
    	html => qr/The current lunar phase is/
    ),
);

done_testing;
