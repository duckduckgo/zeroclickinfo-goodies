#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_ngzhian";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::ngzhian )],
    'duckduckhack ngzhian' => test_zci('ngzhian is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack ngzhian is awesome' => undef,
);

done_testing;
