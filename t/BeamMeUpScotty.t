#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "beam_me_up_scotty";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::BeamMeUpScotty )],
    'beam me up scotty' => test_zci(
        'Aye, aye, captain.',
        structured_answer => {
            input     => ['Beam me up, Scotty'],
            operation => 'Code phrase',
            result    => 'Aye, aye, captain.'
        }
    ),
    'beam us up scotty' => test_zci(
        'Aye, aye, captain.',
        structured_answer => {
            input     => ['Beam me up, Scotty'],
            operation => 'Code phrase',
            result    => 'Aye, aye, captain.'
        }
    ),
    'beam me up' => undef,
    'scotty beam us up' => undef,
);

done_testing;
