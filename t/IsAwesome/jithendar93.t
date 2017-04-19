#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_jithendar93";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::jithendar93
    )],
    'duckduckhack jithendar93' => test_zci('jithendar93 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack jithendar93 is awesome' => undef,
);

done_testing;
