#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_wongalvis";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::wongalvis
    )],
    'duckduckhack wongalvis' => test_zci('wongalvis is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack wongalvis is awesome' => undef,
);

done_testing;
