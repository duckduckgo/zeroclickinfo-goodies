#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'reverse_ip';
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::ReverseIP )],
    '8.8.8.256'             => undef,                                                                             # Not an IP address
    '8.8.8.8.8'             => undef,
    '208.43.32.125.'        => undef,
    '127.0.0.01'            => undef,                                                                             # Not a well-formed IP address
    'ip 208.43.32.125'      => undef,                                                                             # Extra stuff with IP
    '208.43.32.125 reverse' => undef,
    '208.43.32.125'         => test_zci('duckco.com.32.43.208.in-addr.arpa. (Reverse DNS for 208.43.32.125)'),    # Answers!
    '127.0.0.1'             => test_zci('localhost. (Reverse DNS for 127.0.0.1)'),
);

done_testing;
