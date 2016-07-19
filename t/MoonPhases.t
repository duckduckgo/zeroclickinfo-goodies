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

sub build_test {
    return test_zci($ascii_answer, structured_answer => {
        data => {
            title => re($phases),
            subtitle => 'Current lunar phase'
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::MoonPhases)],
    'moon phase' => build_test(),
    'lunar phase' => build_test(),
    'phase of the moon' => build_test(),
    'what is the current lunar phase' => build_test()
);

done_testing;
