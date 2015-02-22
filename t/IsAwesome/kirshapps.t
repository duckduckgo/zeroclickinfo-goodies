#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::goodie;

zci answer_type => "is_awesome_kirshapps";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::goodie::IsAwesome::kirshapps
    )],
    'duckduckhack kirshapps' => test_zci('kirshapps is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack kirshapps is awesome' => undef,
);

done_testing;
