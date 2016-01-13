#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => "german_phone_prefix";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::GermanPhonePrefix )],
    'vorwahl 05491'         => test_zci(
                                'Damme Dümmer',
                                structured_answer => {
                                    input => ['05491'],
                                    operation => "Lookup German phone prefix",                                                                                                                                                                                       
                                    result => "Damme D&uuml;mmer"                 
                                }),
    'telefonvorwahl 040'    => test_zci(
                                'Glinde Kr Stormarn, Hamburg, Reinbek, Stapelfeld b Hamburg, Wentorf b Hamburg',
                                structured_answer => {
                                    input => ['040'],
                                    operation => "Lookup German phone prefix",                                                                                                                                                                                       
                                    result => 'Glinde Kr Stormarn, Hamburg, Reinbek, Stapelfeld b Hamburg, Wentorf b Hamburg'              
                                }),
    'telefonvorwahl 089'    => test_zci(
                                'München',
                                structured_answer => {
                                    input => ['089'],
                                    operation => "Lookup German phone prefix",                                                                                                                                                                                       
                                    result => 'M&uuml;nchen'              
                                }),
    'vorwahl 12345' => undef,
    'vorwahl 12' => undef,
    'vorwahl 1234567' => undef,
    'vorwahl' => undef
);

done_testing;
