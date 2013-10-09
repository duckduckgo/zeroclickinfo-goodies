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
	"Network: 10.0.0.0/24\nType: Network\nClass: A\nHost Address Range: 10.0.0.1-10.0.0.254\nUsable Addresses: 254\nBroadcast: 10.0.0.255\n",
	html => "<div><i>Network: </i>10.0.0.0/24</div><div><i>Type: </i>Network</div><div><i>Class: </i>A</div><div><i>Host Address Range: </i>10.0.0.1-10.0.0.254</div><div><i>Usable Addresses: </i>254</div><div><i>Broadcast: </i>10.0.0.255</div>",
    ),
    "192.168.0.0/24" => test_zci(
	"Network: 192.168.0.0/24\nType: Network\nClass: C\nHost Address Range: 192.168.0.1-192.168.0.254\nUsable Addresses: 254\nBroadcast: 192.168.0.255\n",
	html => "<div><i>Network: </i>192.168.0.0/24</div><div><i>Type: </i>Network</div><div><i>Class: </i>C</div><div><i>Host Address Range: </i>192.168.0.1-192.168.0.254</div><div><i>Usable Addresses: </i>254</div><div><i>Broadcast: </i>192.168.0.255</div>",
    ),
    "8.8.8.8 255.255.224.0" => test_zci(
	"Network: 8.8.0.0/19\nType: Host #2056\nClass: A\nHost Address Range: 8.8.0.1-8.8.31.254\nUsable Addresses: 8190\nBroadcast: 8.8.31.255\n",
	html => "<div><i>Network: </i>8.8.0.0/19</div><div><i>Type: </i>Host #2056</div><div><i>Class: </i>A</div><div><i>Host Address Range: </i>8.8.0.1-8.8.31.254</div><div><i>Usable Addresses: </i>8190</div><div><i>Broadcast: </i>8.8.31.255</div>",
    ),
);

done_testing;
