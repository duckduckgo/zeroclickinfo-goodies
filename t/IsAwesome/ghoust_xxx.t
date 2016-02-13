#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_ghoust_xxx";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::ghoust_xxx
    )],
    'duckduckhack ghoust_xxx' =>
        test_zci('ghoust_xxx is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack ghoust_xxx is awesome' => undef,
);

done_testing;
