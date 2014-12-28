#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "mac_address";
zci is_cached   => 1;

my @dlink = (
    "The OUI, 14:d6:4d, for this NIC was manufactured by D-Link International",
    structured_answer => {
        input     => ["14:d6:4d:da:79:6a"],
        operation => "mac address",
        result    => "<strong>D-Link International</strong><br/>1 INTERNATIONAL BUSINESS PARK<br/>#03-12, THE SYNERGY<br/>609917<br/>SINGAPORE"
    });
my @hp = (
    "The OUI, 2c:41:38, for this NIC was manufactured by Hewlett-Packard Company",
    structured_answer => {
        input     => ["2c:41:38:13:48:d2"],
        operation => "mac address",
        result    => "<strong>Hewlett-Packard Company</strong><br/>11445 Compaq Center Drive<br/>Mailcode 6.3.049<br/>Houston Texas 77070<br/>UNITED STATES"
    });
my @xerox = (
    "The OUI, 00:00:03, for this NIC was manufactured by XEROX CORPORATION",
    structured_answer => {
        input     => ["00:00:03:ff:ff:ff"],
        operation => "mac address",
        result    => "<strong>XEROX CORPORATION</strong><br/>ZEROX SYSTEMS INSTITUTE<br/>M/S 105-50CEW AVENUE 800 PHILLIPS ROAD<br/>WEBSTER NY 14580<br/>UNITED STATES"
    });
my @private = (
    "The OUI, 3c:b8:7a, for this NIC was manufactured by PRIVATE",
    structured_answer => {
        input     => ["3c:b8:7a:94:f5:42:e3:77"],
        operation => "mac address",
        result    => "<strong>PRIVATE</strong><br/>No associated address"
    });


ddg_goodie_test(
    [qw(
        DDG::Goodie::MacAddress
    )],
    'mac address 14:D6:4D:DA:79:6A' => test_zci(@dlink),
    'mac address 14-D6-4D-DA-79-6A' => test_zci(@dlink),
    'mac address 14/D6/4D/DA/79/6A' => test_zci(@dlink),
    'mac address 14.D6.4D.DA.79.6A' => test_zci(@dlink),
    'mac address 14 D6 4D DA 79 6A' => test_zci(@dlink),
    'mac address 14:D6-4D/DA.79 6A' => test_zci(@dlink),
    'mac address 14D64D:/ .-DA796A' => test_zci(@dlink),
    'mac address 14D6-4DDA.796A' => test_zci(@dlink),
    'mac address 14D:64DDA7/96A' => test_zci(@dlink),
    'mac address 14D64DDA796A' => test_zci(@dlink),
    'mac address 2c-41-38-13-48-d2' => test_zci(@hp),
    'mac address 3cb8.7a94.f542.e377' => test_zci(@private),
    'ethernet address 00/00-03.ff:ff:FF' => test_zci(@xerox),
    'mac address 1E:00:00:00:00:00' => undef,
);

done_testing;
