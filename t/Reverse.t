#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'reverse';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Reverse )],
    # Primary example query
    'reverse text esrever' => test_zci(
        'Reversed "esrever": reverse',
        structured_answer => {
            input     => ['esrever'],
            operation => 'Reverse string',
            result    => 'reverse'
        }
    ),
    # Other queries
    'reverse text bla' => test_zci(
        'Reversed "bla": alb',
        structured_answer => {
            input     => ['bla'],
            operation => 'Reverse string',
            result    => 'alb'
        }
    ),
    'reverse text blabla' => test_zci(
        'Reversed "blabla": albalb',
        structured_answer => {
            input     => ['blabla'],
            operation => 'Reverse string',
            result    => 'albalb'
        }
    ),
    'reverse' => undef,

    #Should not trigger on a request for DNA/RNA reverse complement
    'reverse complement of ATG-CTA-GGG-GCT'     => undef,
    'reverse complement gacuacgaucgagkmanscuag' => undef
);

done_testing;

