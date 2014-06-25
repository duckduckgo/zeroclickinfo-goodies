#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'teredo';

ddg_goodie_test(
    [
        'DDG::Goodie::Teredo'
    ],

    # Sample queries
    'teredo 2001:0000:4136:e378:8000:63bf:3fff:fdd2' =>
        test_zci("Teredo Server IPv4: 65.54.227.120\nNAT Public IPv4: 192.0.2.45\nClient Port: 40000",
	html => "<div><span class=\"teredo__label\">Teredo Server IPv4: </span><span>65.54.227.120</span></div><div><span class=\"teredo__label\">NAT Public IPv4: </span><span>192.0.2.45</span></div><div><span class=\"teredo__label\">Client Port: </span><span>40000</span></div><style> .zci--answer .teredo__label {color: #808080; display: inline-block; min-width: 130px}</style>",),
   
    'teredo 2001:0000:4136:E378:8000:EC77:7C94:FFFE' =>
        test_zci("Teredo Server IPv4: 65.54.227.120\nNAT Public IPv4: 131.107.0.1\nClient Port: 5000",
	html => "<div><span class=\"teredo__label\">Teredo Server IPv4: </span><span>65.54.227.120</span></div><div><span class=\"teredo__label\">NAT Public IPv4: </span><span>131.107.0.1</span></div><div><span class=\"teredo__label\">Client Port: </span><span>5000</span></div><style> .zci--answer .teredo__label {color: #808080; display: inline-block; min-width: 130px}</style>",),

    'teredo 2001::CE49:7601:E866:EFFF:62C3:FFFE' =>
        test_zci("Teredo Server IPv4: 206.73.118.1\nNAT Public IPv4: 157.60.0.1\nClient Port: 4096",
	html => "<div><span class=\"teredo__label\">Teredo Server IPv4: </span><span>206.73.118.1</span></div><div><span class=\"teredo__label\">NAT Public IPv4: </span><span>157.60.0.1</span></div><div><span class=\"teredo__label\">Client Port: </span><span>4096</span></div><style> .zci--answer .teredo__label {color: #808080; display: inline-block; min-width: 130px}</style>",),
);


done_testing;
