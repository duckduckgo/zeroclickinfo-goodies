#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "stardate";
zci is_cached   => 0;

sub build_structured_answer {
    return re(qr/[0-9]{8}\.[0-9]{1,5}/),
        structured_answer => {
            data => ignore(),
            templates => {
                group => 'text',
            },
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Stardate )],
    'stardate' => build_test(),
    'stardate 2 months ago' => build_test(),
    'stardate in 2 years' => build_test(),
    'star date' => undef,
    'stardate 29 feb 2015' => undef,
);

done_testing;
