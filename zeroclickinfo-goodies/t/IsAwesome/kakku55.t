#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_kakku55";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::kakku55
    )],
    'duckduckhack kakku55' => test_zci('kakku55 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack kakku55 is awesome' => undef,
);

done_testing;
