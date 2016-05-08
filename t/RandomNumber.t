#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'rand';
zci is_cached => 0;

sub build_structured_answer {
    my ($numberOne, $numberTwo, $response) = @_;
    return $response,
    structured_answer => {
        data => {
            title    => $response,
            subtitle => "Random number between $numberOne - $numberTwo"
        },
        templates => {
            group => "text",
        }
    }
}

sub build_test {test_zci(build_structured_answer(@_))}

ddg_goodie_test(
    [qw( DDG::Goodie::RandomNumber )],
    'random number between 12 and 45' => build_test(12, 45, re /\d{2} \(random number\)/),
    'random number'                   => build_test(0, 1, re /\d{1}\.\d+ \(random number\)/),
    'random number between 0 and 1'   => build_test(0, 1, re /\d{1} \(random number\)/),
    'random number between 0 and 10'  => build_test(0, 10, re /\d{1,2} \(random number\)/),
    'random number between 0 and 100' => build_test(0, 100, re /\d{1,3} \(random number\)/),
    'random day'                      => undef,
    'random access'                   => undef
);
done_testing
