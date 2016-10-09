#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci is_cached => 1;
zci answer_type => 'ohms';

sub build_structured_answer {
    my ($exp_input, $exp_result) = @_;
    return "A $exp_input resistor has a resistance of $exp_result", structured_answer => {
        data => {
            title    => "$exp_result",
            subtitle => "Resistance of $exp_input resistor"
        },
        meta => {
            sourceName => "Wikipedia",
            sourceUrl => "https://en.wikipedia.org/wiki/Electronic_color_code"
        },
        templates => {
            group => 'text',
            options => {          
                moreAt => 1,
            }
        }
    };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw(
        DDG::Goodie::ReverseResistorColours
    )],
    'black green red resistor'              => build_test('black green red', '500 Ω ± 20%'),
    'red orange yellow gold resistor'       => build_test('red orange yellow gold', '230 kΩ ± 5%'),
    'yellow blue purple resistor'           => build_test('yellow blue violet', '460 MΩ ± 20%'),
    'resistor yellow green'                 => undef,
    'resistor red orange blue red green'    => undef,
    'resistor red banana orangutan'         => undef,
    'red yellow white gold resistor'        => build_test('red yellow white gold', '24 GΩ ± 5%'),
    'resistor red yellow white'             => build_test('red yellow white', '24 GΩ ± 20%'),
    'brown black gold silver resistor'      => build_test('brown black gold silver', '1 Ω ± 10%'),
    'brown black silver gold resistor'      => build_test('brown black silver gold', '0.1 Ω ± 5%')
);

done_testing;
