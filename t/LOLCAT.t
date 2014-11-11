#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "lolcat";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::LOLCAT )],
    'lolcat cheese' => test_zci(qr/CHEE/),
    'lolcat who' => test_zci(qr/HOO/),
    'bad example query' => undef,
);

done_testing;
