#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "national_anthems";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::NationalAnthems )],
    'national anthem of wonderland' => undef,
);

done_testing;
