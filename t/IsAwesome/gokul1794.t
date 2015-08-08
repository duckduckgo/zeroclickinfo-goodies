#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_gokul1794";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::gokul1794
    )],
    'duckduckhack gokul1794' => test_zci('gokul1794 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack gokul1794 is awesome' => undef,
);
done_testing;
