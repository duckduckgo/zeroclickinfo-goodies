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
	"10.0.0.0/24" => test_zci("Network: 10.0.0.0/24, Netmask: 255.255.255.0, Network specified, Host Address Range: 10.0.0.1-10.0.0.254, 254 Usable Addresses, Broadcast: 10.0.0.255"),
	"192.168.0.0/24" => test_zci("Network: 192.168.0.0/24, Netmask: 255.255.255.0, Network specified, Host Address Range: 192.168.0.1-192.168.0.254, 254 Usable Addresses, Broadcast: 192.168.0.255"),
	"8.8.8.8 255.255.224.0" => test_zci("Network: 8.8.0.0/19, Netmask: 255.255.224.0, Host #2056 specified, Host Address Range: 8.8.0.1-8.8.31.254, 8190 Usable Addresses, Broadcast: 8.8.31.255"),
	"4.4.4.255/24" => test_zci("Network: 4.4.4.0/24, Netmask: 255.255.255.0, Broadcast specified, Host Address Range: 4.4.4.1-4.4.4.254, 254 Usable Addresses, Broadcast: 4.4.4.255"),
	"42.24.42.24/17" => test_zci("Network: 42.24.0.0/17, Netmask: 255.255.128.0, Host #10776 specified, Host Address Range: 42.24.0.1-42.24.127.254, 32766 Usable Addresses, Broadcast: 42.24.127.255"),
	"172.32.1.3/31" => test_zci("Network: 172.32.1.2/31, Netmask: 255.255.255.254, Point-To-Point (172.32.1.2, 172.32.1.3) specified"),
	"10.255.255.16/32" => test_zci("Network: 10.255.255.16/32, Netmask: 255.255.255.255, Host Only specified"),
	"10.1.2.3/255.0.0.0" => test_zci("Network: 10.0.0.0/8, Netmask: 255.0.0.0, Host #66051 specified, Host Address Range: 10.0.0.1-10.255.255.254, 16777214 Usable Addresses, Broadcast: 10.255.255.255"),
	"192.168.16.1 23" => test_zci("Network: 192.168.16.0/23, Netmask: 255.255.254.0, Host #1 specified, Host Address Range: 192.168.16.1-192.168.17.254, 510 Usable Addresses, Broadcast: 192.168.17.255")
);

done_testing;