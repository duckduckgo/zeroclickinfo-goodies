#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'panchangam';
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::Panchangam
    )],

    #Tithis correlated with http://panchangam.com/
    #Primary example
    'panchangam' => test_zci(qr/Tithi/, html => qr/Tithi/, is_cached => 0),
    'panchangam 2014-08-07' => test_zci(qr/Shukla Ekadashi/, html => qr/Shukla Ekadashi/),

    #Secondary examples
    'panchangam for 2 January 1970' => test_zci(qr/Krishna Navami/, html => qr/Krishna Navami/),
    'panchangam on 12/12/2012' => test_zci(qr/Krishna Chaturdashi/, html => qr/Krishna Chaturdashi/),
    'panchangam last jun' => test_zci(qr/Tithi/, html => qr/Tithi/, is_cached => 0),
    'panchangam dec' => test_zci(qr/Tithi/, html => qr/Tithi/, is_cached => 0),

    #Alternative triggers
    'panjika' => test_zci(qr/Tithi/, html => qr/Tithi/, is_cached => 0),
    'panjika on 12/12/2012' => test_zci(qr/Krishna Chaturdashi/, html => qr/Krishna Chaturdashi/),
    'hindu calendar' => test_zci(qr/Tithi/, html => qr/Tithi/, is_cached => 0),

    #Should not trigger
    'wikipedia panchangam' => undef,
    'what is panchangam' => undef,
    'what is varjya in panchangam' => undef,
    'buy 2014 panchangam' => undef,

);

done_testing;

