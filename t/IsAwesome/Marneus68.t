#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_marneus68";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::Marneus68
    )],
    'duckduckhack Marneus68' => test_zci('Marneus68 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack Marneus68 is awesome' => undef,
);

done_testing;
