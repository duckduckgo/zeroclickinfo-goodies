#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'fortune';
zci is_cached   => 0;

sub build_test
{
    return test_zci(re(qr/.+/), structured_answer => {
        data => {
            title => re(qr/.+/),
            subtitle => 'Random Fortune'
        },
        templates => {
            group => 'text'
        }
    })
}

ddg_goodie_test(
    [qw( DDG::Goodie::Fortune )],
    'gimmie a fortune cookie'           => build_test(),
    'gimmie a unix fortune'             => build_test(),
    'give me a fortune cookie'          => build_test(),
    'give me a unix fortune'            => build_test(),
    'unix fortune cookie'               => build_test(),
    'how do I make a fortune overnight' => undef,
    "bill gates' fortune"               => undef,
);

done_testing;
