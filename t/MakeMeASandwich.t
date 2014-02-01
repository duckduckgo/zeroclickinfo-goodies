#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => 'makemeasandwich';

ddg_goodie_test(
    [
        'DDG::Goodie::MakeMeASandwich'
    ],
    'make me a sandwich' =>
        test_zci(
            'What? Make it yourself.',
            html => 'What? Make it yourself. <a href="http://xkcd.com/149/">XKCD</a>'
        ),
    'sudo make me a sandwich' =>
        test_zci(
            'Okay.',
            html => 'Okay. <a href="http://xkcd.com/149/">XKCD</a>'
        ),     
);

done_testing;
