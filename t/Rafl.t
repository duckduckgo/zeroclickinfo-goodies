#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rafl';
zci is_cached   => 1;

my $intro = qr/^rafl is so everywhere, /;
my @rafl  = (
    $intro,
    structured_answer => {
        input     => ['rafl'],
        operation => 'rafl',
        result    => $intro
    });

ddg_goodie_test(
    [qw( DDG::Goodie::Rafl)],
    'rafl'               => test_zci(@rafl),
    'rafl is everywhere' => test_zci(@rafl),
    'where is rafl?'     => test_zci(@rafl),
);

done_testing;
