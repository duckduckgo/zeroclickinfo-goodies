#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "MAC Address";
zci is_cached   => 0;

my $mac_regxp  = "([0-9A-F]{2}[:-]){5}([0-9A-F]{2})";
my $text_start = "Here's a random MAC address: ";

sub build_test
{
    return test_zci(re(qr/^$text_start$mac_regxp$/), structured_answer => {
        data => {
            title => re($mac_regxp),
            subtitle => "Random MAC Address"
        },
        templates => {
            group => 'text'
        }
    });
}

#regexp from http://stackoverflow.com/questions/4260467/what-is-a-regular-expression-for-a-mac-address
ddg_goodie_test(
    ['DDG::Goodie::GenerateMAC'],
    'generate mac address'        => build_test(),
    'generate mac addr'           => build_test(),
    'random mac address'          => build_test(),
    'random mac addr'             => build_test(),
    'please generate mac address' => build_test(),
);

done_testing;
