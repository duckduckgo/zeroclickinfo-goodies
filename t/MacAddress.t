#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "mac_address";
zci is_cached   => 1;

sub build_test 
{
    my($text, $name, $lines, $input) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title   => $name,
            result => $lines,
            input  => $input,
            infoboxData => [
                {heading => "Related Queries",},
                {
                    label => 'generate mac address',
                    url => 'https://duckduckgo.com/?q=generate+mac+address&ia=answer'
                }, {
                    label => 'random mac address',
                    url => 'https://duckduckgo.com/?q=random+mac+address&ia=answer'
                },
            ]
        },
        templates => {
            group => 'text',
            options => {
                content => 'DDH.mac_address.content'
            }
        }
    });
}

my @dlink = (
    "The OUI, 14:d6:4d, for this NIC is assigned to D-Link International",
    "D-Link International",
    ["1 International Business Park", "#03-12, The Synergy", "609917", "Singapore"],
    "14:d6:4d:da:79:6a"
);
my @hp = (
    "The OUI, 2c:41:38, for this NIC is assigned to Hewlett-Packard Company",
    "Hewlett-Packard Company",
    ["11445 Compaq Center Drive", "Mailcode 6.3.049", "Houston Texas 77070", "United States"],
    "2c:41:38:13:48:d2"
);
my @xerox = (
    "The OUI, 00:00:03, for this NIC is assigned to XEROX CORPORATION",
    "Xerox Corporation",
    ["Zerox Systems Institute", "M/S 105-50cew Avenue 800 Phillips Road", "Webster Ny 14580", "United States"],
    "00:00:03:ff:ff:ff"
);
my @private = (
    "The OUI, 3c:b8:7a, for this NIC is assigned to PRIVATE",
    "Private",
    [],
    "3c:b8:7a:94:f5:42:e3:77"
);

ddg_goodie_test(
    [qw(DDG::Goodie::MacAddress)],
    'mac address 14:D6:4D:DA:79:6A' => build_test(@dlink),
    'mac address 14-D6-4D-DA-79-6A' => build_test(@dlink),
    'mac address 14/D6/4D/DA/79/6A' => build_test(@dlink),
    'mac address 14.D6.4D.DA.79.6A' => build_test(@dlink),
    'mac address 14 D6 4D DA 79 6A' => build_test(@dlink),
    'mac address 14:D6-4D/DA.79 6A' => build_test(@dlink),
    'mac address 14D64D:/ .-DA796A' => build_test(@dlink),
    'mac address 14D6-4DDA.796A' => build_test(@dlink),
    'mac address 14D:64DDA7/96A' => build_test(@dlink),
    'mac address 14D64DDA796A' => build_test(@dlink),
    'mac address 2c-41-38-13-48-d2' => build_test(@hp),
    'mac address 3cb8.7a94.f542.e377' => build_test(@private),
    'ethernet address 00/00-03.ff:ff:FF' => build_test(@xerox),
    'mac address 1E:00:00:00:00:00' => undef,
);

done_testing;
