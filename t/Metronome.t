#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'metronome';
zci is_cached   => 1;

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
                title => 'Metronome' 
            },
            templates => {
                group       => 'base',
                detail      => 'DDH.metronome.metronome'
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Metronome )],

    'metronome' => build_test(),

    'online metronome' => undef,
    'dr. beat metronome' => undef,
    'what is a metronome' => undef,
    'online metronome for practicing music' => undef,
    'metronomes' => undef,
    'buy metronomes and sheet music' => undef,
);

done_testing;
