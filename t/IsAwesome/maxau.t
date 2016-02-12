#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_maxau";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::maxau )],
    'duckduckhack maxau' => test_zci('maxau is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack maxau is awesome' => undef,
);

done_testing;
