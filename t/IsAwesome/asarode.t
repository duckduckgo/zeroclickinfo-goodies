#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_asarode";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::asarode
    )],
    'duckduckhack asarode' => test_zci('asarode is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack asarode is awesome' => undef,
);

done_testing;
