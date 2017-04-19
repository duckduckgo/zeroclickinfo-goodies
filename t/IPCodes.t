#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "ipcodes";
zci is_cached   => 1;

my @ip68_ans = test_zci('Particle protection: Dust tight; Water protection: Immersion greater than 1 m',
    	structured_answer => {
    		input => ['IP68'],
    		operation => "IP Code",
    		result => "Particle protection: Dust tight; Water protection: Immersion greater than 1 m"
    	});

ddg_goodie_test(
    [qw( DDG::Goodie::IPCodes )],
    'IP68' => @ip68_ans,
    'ip 68' => @ip68_ans,
    'IP4X' => test_zci('Particle protection: Wire; Water protection: Unspecified',
    	structured_answer => {
    		input => ['IP4X'],
    		operation => "IP Code",
    		result => "Particle protection: Wire; Water protection: Unspecified"
    	}),
    'IP 99' => undef,
    'ip 4K' => undef,
    'ip address' => undef
);

done_testing;
