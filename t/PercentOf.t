#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "percent_of";
zci is_cached   => 1;

sub build_test {
    my ($answer, $input) = @_;
    return test_zci("Result: $answer", structured_answer => {
        data => {
            title => $answer,
            subtitle => "Calculate: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::PercentOf )],

    '4+50%' => build_test(6,'4+50%'),
    '456+120%' => build_test('1003.2', '456+120%'),

    '3.4+6%' => build_test('3.604', '3.4+6%'),

    '323.7+ 55.3%' => build_test('502.7061', '323.7+55.3%'),

    '577.40*5%' => build_test('28.87', '577.40*5%'),

    '$577.40 *0.5%' => build_test('2.887', '$577.40*0.5%'),

    '200 - 50%' => build_test('100', '200-50%'),
    '234 / 25%' => build_test('936', '234/25%'),

    '$123 + 10% =' => build_test('135.3', '$123+10%='),
    '1.75*5% =' => build_test('0.0.0875', '1.75*5%='),

    '200+50-10%' => undef,
    'urldecode hello%20there' => undef,
    '34$+16' => undef,
    '12+5t%' => undef
);

done_testing;
