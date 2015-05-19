#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "ipcodes";
zci is_cached   => 1;

my @ip67_ans = test_zci('Particle protection: Dust tight; Water protection: Immersion to 1 m',
    	structured_answer => {
    		input => ['IP67'],
    		operation => "IP Code",
    		result => "Particle protection: Dust tight; Water protection: Immersion to 1 m"
    	});

ddg_goodie_test(
    [qw( DDG::Goodie::IPCodes )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'IP67' => @ip67_ans,
    'ip 67' => @ip67_ans,
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'IP 99' => undef,
    'ip 4K' => undef,
    'ip address' => undef
);

done_testing;
