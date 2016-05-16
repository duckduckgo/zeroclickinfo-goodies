#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'aspect_ratio';
zci is_cached => 1;

sub build_structured_answer {
    my ($pretty_ratio, $result) = @_;
    return 'Aspect ratio: ' . $result . ' (' . $pretty_ratio . ')',
        structured_answer => {
            data => {
                title    => $result,
                subtitle => 'Aspect ratio: ' . $pretty_ratio
            },
            templates => {
                group => 'text'
            }
        }
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw(DDG::Goodie::AspectRatio)],

    'aspect ratio 4:3 640:?'  => build_test('4:3', '640:480'),
    'aspect ratio 4:3 ?:480'  => build_test('4:3', '640:480'),
    'aspect ratio 1:1.5 20:?' => build_test('1:1.5', '20:30'),
    'aspect ratio 1:1.5 ?:15' => build_test('1:1.5', '10:15')
);

done_testing;
