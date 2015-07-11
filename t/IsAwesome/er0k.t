#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_er0k";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::er0k )],
    'duckduckhack er0k' => test_zci(':)'),
    'duckduckhack er0k is awesome' => undef,
);

done_testing;
