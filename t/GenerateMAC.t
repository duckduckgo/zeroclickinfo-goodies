#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "MAC Address";
zci is_cached   => 0;

my $mac_regxp  = "([0-9A-F]{2}[:-]){5}([0-9A-F]{2})";
my $text_start = "Here's a random MAC address: ";

my @answer = (
    qr/^$text_start$mac_regxp$/,
    structured_answer => {
        input     => [],
        operation => 'random MAC address',
        result    => qr/$mac_regxp/
    });

#regexp from http://stackoverflow.com/questions/4260467/what-is-a-regular-expression-for-a-mac-address
ddg_goodie_test(
    ['DDG::Goodie::GenerateMAC'],
    'generate mac address'        => test_zci(@answer),
    'generate mac addr'           => test_zci(@answer),
    'random mac address'          => test_zci(@answer),
    'random mac addr'             => test_zci(@answer),
    'please generate mac address' => test_zci(@answer),
);

done_testing;
