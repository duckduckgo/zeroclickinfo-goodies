#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'metronome';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my @test_params = @_;

    return '',
        structured_answer => {
            id => 'metronome',
            name => 'Metronome',
            signal => 'high',
            meta => {
                sourceName => 'Metronome',
                itemType => 'metronome'
            },
            data => {
                remainder => $_ 
            },
            templates => {
                group       => 'base',
                detail      => 'DDH.metronome.metronome'
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Metronome )],

    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'metronome' => build_test(),
    'online metronome' => build_test(),
    'dr. beat metronome' => build_test(),
    'what is a metronome' => build_test(),

    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'online metronome for practicing music' => undef,
    'metronomes' => undef,
    'buy metronomes and sheet music' => undef,
);

done_testing;
