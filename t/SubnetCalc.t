#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'subnet_info';
zci is_cached => 1;

ddg_goodie_test(
    [
        # This is the name of the goodie that will be loaded to test.
        'DDG::Goodie::SubnetCalc'
    ],
    "10.0.0.0/24" => test_zci(
	"Network: 10.0.0.0/24 (Class A)\nSpecified: Network\nHost Address Range: 10.0.0.1-10.0.0.254 (254 hosts)\nBroadcast: 10.0.0.255\n",
	html => "<div><i>Network: </i>10.0.0.0/24 (Class A)</div><div><i>Specified: </i>Network</div><div><i>Host Address Range: </i>10.0.0.1-10.0.0.254 (254 hosts)</div><div><i>Broadcast: </i>10.0.0.255</div>",
    ),
    "192.168.0.0/24" => test_zci(
	"Network: 192.168.0.0/24 (Class C)\nSpecified: Network\nHost Address Range: 192.168.0.1-192.168.0.254 (254 hosts)\nBroadcast: 192.168.0.255\n",
	html => "<div><i>Network: </i>192.168.0.0/24 (Class C)</div><div><i>Specified: </i>Network</div><div><i>Host Address Range: </i>192.168.0.1-192.168.0.254 (254 hosts)</div><div><i>Broadcast: </i>192.168.0.255</div>",
    ),
    "8.8.8.8 255.255.224.0" => test_zci(
	"Network: 8.8.0.0/19 (Class A)\nSpecified: Host #2056\nHost Address Range: 8.8.0.1-8.8.31.254 (8190 hosts)\nBroadcast: 8.8.31.255\n",
	html => "<div><i>Network: </i>8.8.0.0/19 (Class A)</div><div><i>Specified: </i>Host #2056</div><div><i>Host Address Range: </i>8.8.0.1-8.8.31.254 (8190 hosts)</div><div><i>Broadcast: </i>8.8.31.255</div>",
    ),
);

done_testing;
