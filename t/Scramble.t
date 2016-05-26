#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "scramble";
zci is_cached   => 0;

sub build_test {
    my ($text, $input) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => ignore(),
            subtitle => "Scramble of: $input"
        },
        templates => {
            group => 'text'
        }
    });
}


ddg_goodie_test(
    [qw( DDG::Goodie::Scramble )],
    'scramble of filter'       => build_test('Scramble of filter', 'filter'),
    'scramble of'              => undef,
    'Scramble for'             => undef,
    'Scrambles for ""'         => undef,
    'Scrambles for "867-5309"' => undef,
);

done_testing;
