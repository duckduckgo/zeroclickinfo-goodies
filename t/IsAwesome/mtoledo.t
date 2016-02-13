#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_mtoledo";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::mtoledo
    )],
    'duckduckhack mtoledo' => test_zci('mtoledo has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack mtoledo is awesome' => undef,
);

done_testing;
