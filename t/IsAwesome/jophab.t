#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_jophab";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::jophab
    )],
    'duckduckhack jophab' => test_zci('jophab is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack jophab is awesome' => undef,
);
done_testing;