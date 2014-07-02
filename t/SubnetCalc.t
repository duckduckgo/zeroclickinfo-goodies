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
	"Network: 10.0.0.0/24 (Class A)\nNetmask: 255.255.255.0\nSpecified: Network\nHost Address Range: 10.0.0.1-10.0.0.254 (254 hosts)\nBroadcast: 10.0.0.255\n", html => qr/.*/),
    
    "192.168.0.0/24" => test_zci(
	"Network: 192.168.0.0/24 (Class C)\nNetmask: 255.255.255.0\nSpecified: Network\nHost Address Range: 192.168.0.1-192.168.0.254 (254 hosts)\nBroadcast: 192.168.0.255\n",html => qr/.*/),

    "8.8.8.8 255.255.224.0" => test_zci(
	"Network: 8.8.0.0/19 (Class A)\nNetmask: 255.255.224.0\nSpecified: Host #2056\nHost Address Range: 8.8.0.1-8.8.31.254 (8190 hosts)\nBroadcast: 8.8.31.255\n", html => qr/.*/),

    '46.51.197.88/255.255.254.0' => test_zci(
    "Network: 46.51.196.0/23 (Class A)\nNetmask: 255.255.254.0\nSpecified: Host #344\nHost Address Range: 46.51.196.1-46.51.197.254 (510 hosts)\nBroadcast: 46.51.197.255\n", html => qr/.*/),

    '176.34.131.233/32' => test_zci(
    "Network: 176.34.131.233/32 (Class B)\nNetmask: 255.255.255.255\nSpecified: Host Only\n", html => qr/.*/),
);

done_testing;
