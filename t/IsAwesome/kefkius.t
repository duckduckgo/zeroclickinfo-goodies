#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_kefkius";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::kefkius )],
    'duckduckhack kefkius' => test_zci('kefkius is awesome, hello world!'),
    'duckduckhack kefkius is awesome' => undef,
);

done_testing;
