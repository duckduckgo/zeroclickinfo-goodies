#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'rand';
zci is_cached => 0;

sub build_structured_answer {
    my ($number_one, $number_two, $response) = @_;
    return $response,
    structured_answer => {
        data => {
            title    => $response,
            subtitle => "Random number between $number_one - $number_two"
        },
        templates => {
            group => "text",
        }
    }
}

sub build_test {test_zci(build_structured_answer(@_))}

my $rand_re = qr/\(random number\)/;

ddg_goodie_test(
    [qw( DDG::Goodie::RandomNumber )],
    
    'random number between 12 and 45' => build_test(12, 45, re(/\d{2} $rand_re/)),
    'random number'                   => build_test(0, 1, re(/\d{1}\.\d+ $rand_re/)),
    'random number between 0 and 1'   => build_test(0, 1, re(/\d{1} $rand_re/)),
    'random number between 0 and 10'  => build_test(0, 10, re(/\d{1,2} $rand_re/)),
    'random number between 0 and 100' => build_test(0, 100, re(/\d{1,3} $rand_re/)),
    'random day'                      => undef,
    'random access'                   => undef
);
done_testing
