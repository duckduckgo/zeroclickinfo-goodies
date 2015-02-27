#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_francisbrito";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::francisbrito
    )],
    'duckduckhack francisbrito' => test_zci('francisbrito is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack francisbrito is awesome' => undef,
);

done_testing;
