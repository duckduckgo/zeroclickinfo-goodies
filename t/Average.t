#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'average';
zci is_cached => 1;

sub build_structured_answer {
    my ($input, $type, $result) = @_;
    return "$type: $result",
        structured_answer => {
            data => {
                title => $result,
                subtitle => "$type of: $input"
            },
            templates => {
                group => 'text'
            }
    };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw(DDG::Goodie::Average)],

    '1 2 3 avg'                   => build_test('1 2 3', 'Mean', '2'),
    'mean 1, 2, 3'                => build_test('1 2 3', 'Mean', '2'),
    'root mean square 1,2,3'      => build_test('1 2 3', 'Root Mean Square', '2.16024689946929'),
    'rms 1,2,3'                   => build_test('1 2 3', 'Root Mean Square', '2.16024689946929'),
    "average 12 45 78 1234.12"    => build_test('12 45 78 1234.12', 'Mean', '342.28'),
    "average 12, 45, 78, 1234.12" => build_test('12 45 78 1234.12', 'Mean', '342.28'),
    "average 12;45;78;1234.12"    => build_test('12 45 78 1234.12', 'Mean', '342.28'),
    'average 12, 45, 78, 1234'    => build_test('12 45 78 1234', 'Mean', '342.25'),
    'median 1,2,3'                => build_test('1 2 3', 'Median', '2'),

    #Should not trigger
    'average temperature philadelphia 2012 january' => undef,
);

done_testing;
