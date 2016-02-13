#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_calavera_the_nine";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::CalaveraTheNine
    )],
    'duckduckhack CalaveraTheNine' => test_zci('CalaveraTheNine is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack CalaveraTheNine is awesome' => undef,
);

done_testing;
