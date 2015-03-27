#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "lorem_ipsum";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::LoremIpsum )],
    'lorem ipsssum 3' => undef,
    'lorem dipsum' => undef,
    'lipsum 10' => test_zci(
        qr/([a-zA-Z. ]+\n\n){9,9}[a-zA-Z. ]+/,
        {
            html => qr/(<p>[a-zA-Z. ]+<\/p>){9,9}<p>[a-zA-Z. ]+<\/p>/
        }),
    'lipsum 100233' => test_zci(
        qr/([a-zA-Z. ]+\n\n){9,9}[a-zA-Z. ]+/,
        {
            html => qr/(<p>[a-zA-Z. ]+<\/p>){9,9}<p>[a-zA-Z. ]+<\/p>/
        }),
    'lorem ipsum' => test_zci(
        qr/([a-zA-Z. ]+\n\n){3,3}[a-zA-Z. ]+/,
        {
            html => qr/(<p>[a-zA-Z. ]+<\/p>){3,3}<p>[a-zA-Z. ]+<\/p>/
        }),
     'lipsum' => test_zci(
        qr/([a-zA-Z. ]+\n\n){3,3}[a-zA-Z. ]+/,
        {
            html => qr/(<p>[a-zA-Z. ]+<\/p>){3,3}<p>[a-zA-Z. ]+<\/p>/
        }),
      'lorem ipsum 6' => test_zci(
        qr/([a-zA-Z. ]+\n\n){5,5}[a-zA-Z. ]+/,
        {
            html => qr/(<p>[a-zA-Z. ]+<\/p>){5,5}<p>[a-zA-Z. ]+<\/p>/
        }),

);

done_testing;
