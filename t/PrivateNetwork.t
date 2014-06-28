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
    html => q#<style type='text/css'>.private_network .left-column {
    vertical-align: top;
    display: inline-block;
    width: 30%;
}

.private_network .right-column {
    vertical-align: top;
    display: inline-block;
    width: 70%;
}</style><div class='private_network'>
<div>
    <div class='text--primary left-column'>
        IPv4 addresses (<a href="https://www.ietf.org/rfc/rfc1918.txt">rfc1918</a>):
    </div>
    <div class='text--secondary right-column'>
        <p>10.0.0.0 - 10.255.255.255 | 10.0.0.0/8</p>
        <p>172.16.0.0 - 172.31.255.255 | 172.16.0.0/12</p>
        <p>192.168.0.0 - 192.168.255.255 | 192.168.0.0/16</p>
    </div>
</div>
<div>
    <div class='text--primary left-column'>
        Carrier NAT (<a href="https://www.ietf.org/rfc/rfc6598.txt">rfc6598</a>):
    </div>
    <div class='text--secondary right-column'>
        100.64.0.0 - 100.127.255.255 | 100.64.0.0/10
    </div>
</div>
<div>
    <div class='text--primary left-column'>
        Test Networks (<a href="https://www.ietf.org/rfc/rfc5735.txt">rfc5735</a>):
    </div>
    <div class='text--secondary right-column'>
        <p>TEST-NET-1: 192.0.2.0 - 192.0.2.255 | 192.0.2.0/24</p>
        <p>TEST-NET-2: 198.51.100.0 - 198.51.100.255 | 198.51.100.0/24</p>
        <p>TEST-NET-3: 203.0.113.0 - 203.0.113.255 | 203.0.113.0/24</p>
        <p>Benchmarks: 198.18.0.1 - 198.19.255.255 | 198.18.0.0/15</p>
    </div>
</div>
<div>
    <div class='text--primary left-column'>
        IPv6 addresses (<a href="https://www.ietf.org/rfc/rfc4193.txt">rfc4193</a>):
    </div>
    <div class='text--secondary right-column'>
        Unique local addresses: fd00::/8
    </div>
</div>
</div>#
)) } ( 'private network', 'private networks', 'private ips' )
);

done_testing;
