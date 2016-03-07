#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "stardate";
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::Stardate )],
    'stardate' => test_zci(
        qr/[0-9]{8}\.[0-9]{1,5}/,
        structured_answer => {
            id => 'stardate',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'star date' => undef,
);

done_testing;
