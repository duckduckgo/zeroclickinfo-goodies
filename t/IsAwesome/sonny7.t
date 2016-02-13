#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_sonny7";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::sonny7
    )],
    'duckduckhack sonny7' => test_zci('sonny7 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack sonny7 is awesome' => undef,
);

done_testing;
