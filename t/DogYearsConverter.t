#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'dog_years_converter';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my ($input, $from, $to, $result) = @_;

    return qq/Dog Year Conversion: $input ($from) = $result ($to)/,
        structured_answer => {
            data => {
              title => $result,
              subtitle =>$from . ' to ' . $to . ': ' . $input
            },
            templates => {
              group => 'text'
            }
    };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw(DDG::Goodie::DogYearsConverter)],
    '1 in dog years'    => build_test('1', 'Human Years', 'Dog Years', '0.142857142857143'),
    '1 into dog years'  => build_test('1', 'Human Years', 'Dog Years', '0.142857142857143'),
    '1 year as dog years'  => build_test('1', 'Human Years', 'Dog Years', '0.142857142857143'),
    '1 human year to dog years'  => build_test('1', 'Human Years', 'Dog Years', '0.142857142857143'),
    '7 into dog years'  => build_test('7', 'Human Years', 'Dog Years', '1'),
    '7 years into dog years'  => build_test('7', 'Human Years', 'Dog Years', '1'),
    '7 human years into dog years'  => build_test('7', 'Human Years', 'Dog Years', '1'),
    '1 from dog years'  => build_test('1', 'Dog Years', 'Human Years', '7'),
    '1 year from dog years'  => build_test('1', 'Dog Years', 'Human Years', '7'),
    '1 human year from dog years'  => build_test('1', 'Dog Years', 'Human Years', '7'),
    '2 years from dog years'  => build_test('2', 'Dog Years', 'Human Years', '14'),
    '2 human years from dog years'  => build_test('2', 'Dog Years', 'Human Years', '14'),
    'dog years' => undef,
    'human years' => undef
);

done_testing;
