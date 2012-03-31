#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 0;

ddg_goodie_test(
        [qw(
                DDG::Goodie::IsItDown
        )],
        'is duckduckgo.com down' => test_zci("duckduckgo.com is up!"),
        'is duckduckgo.com down?' => test_zci("duckduckgo.com is up!"),
        'is notreal_--.com down?' => test_zci("We can't reach notreal_--.com either."),
        'is notreal_--.com down?' => test_zci("We can't reach notreal_--.com either."),
);

done_testing;
