#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'panchangam';

ddg_goodie_test(
	[qw(
		DDG::Goodie::Panchangam
	)],

  #Tithis correlated with http://panchangam.com/
  #Primary example
  'panchangam' => test_zci(qr/Tithi/, html => qr/Tithi/),
  'panchangam 2014-08-07' => test_zci(qr/Shukla Ekadashi/, html => qr/Shukla Ekadashi/),

  #Secondary examples
  'panchangam today' => test_zci(qr/Tithi/, html => qr/Tithi/),
  'panchangam yesterday' => test_zci(qr/Tithi/, html => qr/Tithi/),
  'panchangam tomorrow' => test_zci(qr/Tithi/, html => qr/Tithi/),
  'panchangam for 2 January 1970' => test_zci(qr/Krishna Navami/, html => qr/Krishna Navami/),
  '1 year ago 2014-08-07 panchangam' => test_zci(qr/Amavasya/, html => qr/Amavasya/),
  'panchangam on 12/12/12' => test_zci(qr/Krishna Chaturdashi/, html => qr/Krishna Chaturdashi/),

  #Alternative triggers
  'panjika' => test_zci(qr/Tithi/, html => qr/Tithi/),
  'panjika on 12/12/12' => test_zci(qr/Krishna Chaturdashi/, html => qr/Krishna Chaturdashi/),
  'hindu calendar' => test_zci(qr/Tithi/, html => qr/Tithi/),

  #Should not trigger
  'wikipedia panchangam' => undef,
  'what is panchangam' => undef,
  'what is varjya in panchangam' => undef,
  'buy 2014 panchangam' => undef,

);

done_testing;

