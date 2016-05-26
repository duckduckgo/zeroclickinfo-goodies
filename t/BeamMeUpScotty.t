#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "beam_me_up_scotty";
zci is_cached   => 1;

sub build_structured_answer {
    my $answer = 'Aye, aye, captain.';
    return $answer,
        structured_answer => {
            data => {
                title => $answer,
                subtitle => 'Code phrase: Beam me up, Scotty',
            },
            templates => {
                group => 'text',
            },
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::BeamMeUpScotty )],
    'beam me up scotty' => build_test(),
    'beam us up scotty' => build_test(),
    'beam me up' => undef,
    'scotty beam us up' => undef,
);

done_testing;
