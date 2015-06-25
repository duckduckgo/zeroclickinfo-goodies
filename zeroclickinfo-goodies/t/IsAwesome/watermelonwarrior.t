#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_watermelonwarrior";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::watermelonwarrior )],
    'duckduckhack watermelonwarrior' => test_zci('watermelonwarrior is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack watermelonwarrior is awesome' => undef,
);

done_testing;
