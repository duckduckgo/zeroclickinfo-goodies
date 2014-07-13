#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'reverse';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::Reverse
    )],
    'reverse text bla' => test_zci('Reversed "bla": alb'),
    'reverse text blabla' => test_zci('Reversed "blabla": albalb'),
    'reverse text esrever' => test_zci('Reversed "esrever": reverse'),
    'reverse' => undef,

    #Should not trigger on a request for DNA/RNA reverse complement
    'reverse complement of ATG-CTA-GGG-GCT' => undef,
    'reverse complement gacuacgaucgagkmanscuag' => undef
);

done_testing;

