#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "note_frequency";
zci is_cached   => 1;

sub build_structured_answer {
    my ($input, $frequency) = @_;
    return $frequency,
        structured_answer => {
            data => {
                title    => $frequency." Hz",
                subtitle => "Note Frequency: " . $input,
            },
            templates => {
                group => 'text',
            },
        },
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::NoteFrequency )],
    "notefreq a4"         => build_test("A4 in A440 tuning", "440"),
    "notefreq gb5"        => build_test("Gb5 in A440 tuning", "739.99"),
    "notefreq c3 432"     => build_test("C3 in A432 tuning", "128.43"),
    "notefreq c3 432Hz"   => build_test("C3 in A432 tuning", "128.43"),
    "notefreq c3 432  Hz" => undef,
    "notefreq a4 100000"  => undef,
    "notefreq b#8"        => undef,
    "notefreq cb0"        => undef,
    "notefreq c9"         => undef,
);

done_testing;
