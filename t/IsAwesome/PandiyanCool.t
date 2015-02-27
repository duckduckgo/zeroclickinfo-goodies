#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_pandiyan_cool";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::PandiyanCool
    )],
    'duckduckhack pandiyancool' => test_zci('PandiyanCool is techie saint who always interested to learn new things!'),
    'duckduckhack pandiyancool is techie saint' => undef,
);

done_testing;
