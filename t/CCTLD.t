#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'ccTLD';
zci is_cached => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::CCTLD )],
    '.us' => test_zci(
        '.us is the country code top-level domain for United States.',
        html => '<code>.us</code> is the '
            . '<a href="https://en.wikipedia.org/wiki/Country_code_top-level_domain">'
            . 'country code top-level domain</a> for '
            . '<a href="https://en.wikipedia.org/wiki/United_States">United States</a>.'
    ),
);

done_testing;
