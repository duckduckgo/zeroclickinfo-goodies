#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'date_conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::AltCalendars
        )],
        'heisei 25' => test_zci('2013'),
        'shouwa 39' => test_zci('1964'),
        'taisho 11' => test_zci('1922'),
        'meiji 1' => test_zci('1868'),
        'minguo 50' => test_zci('1961'),
        'juche 07' => test_zci('1918'),
);

done_testing;