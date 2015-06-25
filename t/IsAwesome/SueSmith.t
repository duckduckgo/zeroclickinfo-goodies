#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_sue_smith";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::SueSmith
    )],
    'duckduckhack SueSmith' => test_zci('SueSmith is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack SueSmith is awesome' => undef,
);

done_testing;
