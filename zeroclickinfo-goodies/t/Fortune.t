#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'fortune';
zci is_cached   => 0;

my @fortune = (
    '-ANY-',
    structured_answer => {
        input     => [],
        operation => 'Random fortune',
        result    => '-ANY-'
    });

ddg_goodie_test(
    [qw( DDG::Goodie::Fortune )],
    'gimmie a fortune cookie'           => test_zci(@fortune),
    'gimmie a unix fortune'             => test_zci(@fortune),
    'give me a fortune cookie'         => test_zci(@fortune),
    'give me a unix fortune'           => test_zci(@fortune),
    'unix fortune cookie'               => test_zci(@fortune),
    'how do I make a fortune overnight' => undef,
    "bill gates' fortune"               => undef,
);

done_testing;

