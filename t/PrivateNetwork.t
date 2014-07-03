#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'private_network';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::PrivateNetwork
    )],
    map { ("$_" => test_zci(
        'Private network IPv4 addresses (rfc1918):
10.0.0.0 - 10.255.255.255 | 10.0.0.0/8
172.16.0.0 - 172.31.255.255 | 172.16.0.0/12
192.168.0.0 - 192.168.255.255 | 192.168.0.0/16

Carrier NAT IPv4 private addresses (rfc6598):
100.64.0.0 - 100.127.255.255 | 100.64.0.0/10

Test Networks (rfc5735):
TEST-NET-1: 192.0.2.0 - 192.0.2.255 | 192.0.2.0/24
TEST-NET-2: 198.51.100.0 - 198.51.100.255 | 198.51.100.0/24
TEST-NET-3: 203.0.113.0 - 203.0.113.255 | 203.0.113.0/24
Benchmarks: 198.18.0.1 - 198.19.255.255 | 198.18.0.0/15

Private network IPv6 addresses (rfc4193):
Unique local addresses: fd00::/8
',
    html => qr#.*#
)) } ( 'private network', 'private networks', 'private ips' )
);

done_testing;
