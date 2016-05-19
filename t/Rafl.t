#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'rafl';
zci is_cached   => 1;

my $intro = re(qr/^rafl is so everywhere, /);

sub build_test {
    return test_zci($intro, structured_answer => {
        data => {
            title => $intro,
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Rafl)],
    'rafl'               => build_test(),
    'rafl is everywhere' => build_test(),
    'where is rafl?'     => build_test(),
);

done_testing;
