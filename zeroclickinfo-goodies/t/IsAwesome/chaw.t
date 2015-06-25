#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_chaw";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::chaw
    )],
    'duckduckhack chaw' => test_zci('chaw wishes you Happy Hacking!'),
    'duckduckhack chaw is awesome' => undef,
);


done_testing;
