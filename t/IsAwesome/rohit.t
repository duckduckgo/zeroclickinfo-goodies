#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_rohit";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::rohit
    )],
    'duckduckhack rohit' => test_zci('rohit is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack rohit is awesome' => undef,
);

done_testing;
