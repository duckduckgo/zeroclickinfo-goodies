#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_fabrgu";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::fabrgu )],
    'duckduckhack fabrgu' => test_zci('fabrgu is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack fabrgu is awesome' => undef,
);

done_testing;
