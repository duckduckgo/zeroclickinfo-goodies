#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'moon_phase';
zci is_cached   => 0;

my $space_plus = qr/(?:\s|\+)/;
my $wax_wane   = qr/(?:Waxing|Waning)$space_plus(?:Gibbous|Crescent)/;
my $quarter    = qr/(?:First|Third)$space_plus(?:Quarter)/;
my $named      = qr/(?:New|Full)$space_plus(?:Moon)/;
my $phases     = qr/$wax_wane|$quarter|$named/;

my $ascii_answer = re(qr/^The current lunar phase is: $phases$/);
my $html_answer  = re(qr%^The current lunar phase is: <a href="\?q=$phases">$phases</a>$%);

ddg_goodie_test(
    [qw( DDG::Goodie::MoonPhases)],
    'moon phase' => test_zci(
        $ascii_answer,
        structured_answer => {
            input     => [],
            operation => 'Current lunar phase',
            result    => re($phases),
        }
    ),
    'lunar phase' => test_zci(
        $ascii_answer,
        structured_answer => {
            input     => [],
            operation => 'Current lunar phase',
            result    => re($phases),
        }
    ),
    'phase of the moon' => test_zci(
        $ascii_answer,
        structured_answer => {
            input     => [],
            operation => 'Current lunar phase',
            result    => re($phases),
        }
    ),
    'what is the current lunar phase' => test_zci(
        $ascii_answer,
        structured_answer => {
            input     => [],
            operation => 'Current lunar phase',
            result    => re($phases),
        }
    ),
);

done_testing;
