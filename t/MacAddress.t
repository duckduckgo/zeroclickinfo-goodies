#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "mac_address";
zci is_cached   => 1;

my @dlink = (
    "The OUI, 14:d6:4d, for this NIC is assigned to D-Link International",
    structured_answer => {
        input     => ["14:d6:4d:da:79:6a"],
        operation => "MAC Address",
        result    => "<p class=\"macaddress title\">D-Link International</p><p class=\"macaddress\">1 International Business Park</p><p class=\"macaddress\">#03-12, The Synergy</p><p class=\"macaddress\">609917</p><p class=\"macaddress\">Singapore</p>"
    });
my @hp = (
    "The OUI, 2c:41:38, for this NIC is assigned to Hewlett-Packard Company",
    structured_answer => {
        input     => ["2c:41:38:13:48:d2"],
        operation => "MAC Address",
        result    => "<p class=\"macaddress title\">Hewlett-Packard Company</p><p class=\"macaddress\">11445 Compaq Center Drive</p><p class=\"macaddress\">Mailcode 6.3.049</p><p class=\"macaddress\">Houston Texas 77070</p><p class=\"macaddress\">United States</p>"
    });
my @xerox = (
    "The OUI, 00:00:03, for this NIC is assigned to XEROX CORPORATION",
    structured_answer => {
        input     => ["00:00:03:ff:ff:ff"],
        operation => "MAC Address",
        result    => "<p class=\"macaddress title\">Xerox Corporation</p><p class=\"macaddress\">Zerox Systems Institute</p><p class=\"macaddress\">M/S 105-50cew Avenue 800 Phillips Road</p><p class=\"macaddress\">Webster Ny 14580</p><p class=\"macaddress\">United States</p>"
    });
my @private = (
    "The OUI, 3c:b8:7a, for this NIC is assigned to PRIVATE",
    structured_answer => {
        input     => ["3c:b8:7a:94:f5:42:e3:77"],
        operation => "MAC Address",
        result    => "<p class=\"macaddress title\">Private</p>"
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
