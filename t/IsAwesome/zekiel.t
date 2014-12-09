#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_zekiel";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::zekiel
    )],
    'duckduckhack zekiel' => test_zci('zekiel is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack zekiel is awesome' => undef,
);

done_testing;
