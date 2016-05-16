#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use Regexp::Common;

zci answer_type => 'rand';
zci is_cached => 0;

sub build_structured_answer {
    my ($number_one, $number_two, $response) = @_;
    return re(qr/^$response \(random number\)$/),
    structured_answer => {
        data => {
            title    => re(qr/^$response$/),
            subtitle => "Random number between $number_one - $number_two"
        },
        templates => {
            group => "text",
        }
    }
}

sub build_test {
    test_zci(build_structured_answer(@_));
}

ddg_goodie_test(
    [qw( DDG::Goodie::RandomNumber )],

    'random number between 12 and 45' => build_test(12, 45, qr/\d{2}/),
    'random number'                   => build_test(0, 1, qr/$RE{num}{real}/),
    'random number between 0 and 1'   => build_test(0, 1, qr/$RE{num}{real}/),
    'random number between 0 and 10'  => build_test(0, 10, qr/\d{1,2}/),
    'random number between 0 and 100' => build_test(0, 100, qr/\d{1,3}/),
    'random day'                      => undef,
    'random access'                   => undef
);

done_testing;
