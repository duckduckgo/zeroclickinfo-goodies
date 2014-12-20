#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_ecelis";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::ecelis )],
    'duckduckhack ecelis' => test_zci('ecelis has completed the DuckDuckGoHack goodie tutorial!'),
    'duckduckhack ecelis is awesome' => undef,
);

done_testing;
