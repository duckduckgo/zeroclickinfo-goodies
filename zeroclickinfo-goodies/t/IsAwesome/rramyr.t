#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_rramyr";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::rramyr
    )],
    'duckduckhack rramyr' => test_zci('rramyr is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack rramyr is awesome' => undef,
);

done_testing;