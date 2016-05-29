#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'sort';
zci is_cached   => 1;

sub build_test {
    my ($input, $direction, $result) = @_;
    return test_zci("$result (Sorted $direction)" , structured_answer => {
        data => {
            title => $result,
            subtitle => "Sort $direction: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Sort)],
    'sort -1, +4, -3, 5.7'                      => build_test('-1, +4, -3, 5.7', 'ascendingly', '-3, -1, +4, 5.7'),
    'sort [-1, +4, -3, 5.7]'                    => build_test('-1, +4, -3, 5.7', 'ascendingly', '-3, -1, +4, 5.7'),
    'sort (-1, +4, -3, 5.7)'                    => build_test('-1, +4, -3, 5.7', 'ascendingly', '-3, -1, +4, 5.7'),
    'sort desc -4.4 .5 1 66 15 -55'             => build_test('-4.4, .5, 1, 66, 15, -55', 'descendingly', '66, 15, 1, .5, -4.4, -55'),
    'sort desc -4.4 .5 1 66 2e-3 15 -55'        => build_test('-4.4, .5, 1, 66, 2e-3, 15, -55', 'descendingly', '66, 15, 1, .5, 2e-3, -4.4, -55'),
    'sort -3 -10 56 10'                         => build_test('-3, -10, 56, 10','ascendingly', '-10, -3, 10, 56'),
    'sort descending 10, -1, +5.3, -95, 1'      => build_test('10, -1, +5.3, -95, 1', 'descendingly', '10, +5.3, 1, -1, -95'),
    'sort descending 10, -1, +5.3, -95, 1, 1e2' => build_test('10, -1, +5.3, -95, 1, 1e2', 'descendingly', '1e2, 10, +5.3, 1, -1, -95'),
    'sort 1e700, 1e500, 1e-700'                 => build_test('1e700, 1e500, 1e-700', 'ascendingly','1e-700, 1e700, 1e500'),
    'sort descending 1e700, 1e500, 1e-700'      => build_test('1e700, 1e500, 1e-700', 'descendingly','1e700, 1e500, 1e-700'),
    'sort 455'                                  => undef,
    'sort algorithm'                            => undef,
    'sort 1 fish, 2 fish'                       => undef,
    'sort'                                      => undef
);

done_testing;
