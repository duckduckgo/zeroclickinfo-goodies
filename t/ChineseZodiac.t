#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'chinesezodiac';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::ChineseZodiac
	)],

  #Primary example
  'chinese zodiac for 1969' => test_zci('Rooster', html => qr/Rooster/),

  #Secondary examples
  '2004 chinese zodiac animal' => test_zci('Monkey', html => qr/Monkey/),
  'what was the chinese zodiac animal in 1992' => test_zci('Monkey', html => qr/Monkey/),
  'what will the chinese zodiac animal be for 2056' => test_zci('Rat', html => qr/Rat/),
  'last year\'s chinese zodiac' => test_zci(qr/./, html => qr/./),

  #Primary example with different query formats
  '1969 chinese zodiac animal' => test_zci('Rooster', html => qr/Rooster/),
  'what was the chinese zodiac animal for 1969' => test_zci('Rooster', html => qr/Rooster/),
  'what will the chinese zodiac animal be for people born in the year 1969' => test_zci('Rooster', html => qr/Rooster/),
  'chinese zodiac for a person born in 1969' => test_zci('Rooster', html => qr/Rooster/),
  'chinese zodiac of 1969' => test_zci('Rooster', html => qr/Rooster/),

  #Alternative triggers
  '1969 shēngxiào' => test_zci('Rooster', html => qr/Rooster/),
  'shengxiao animal 1969' => test_zci('Rooster', html => qr/Rooster/),
  'shēng xiào for 1969' => test_zci('Rooster', html => qr/Rooster/),
  'i was born in 1969 what is my sheng xiao' => test_zci('Rooster', html => qr/Rooster/),

  #Test some different years
  # Taken from http://www.chinesezodiac.com/calculator.php
  'chinese zodiac animal for 1924' => test_zci('Rat', html => qr/Rat/),
  'chinese zodiac animal for 1929' => test_zci('Snake', html => qr/Snake/),
  'chinese zodiac animal for 1934' => test_zci('Dog', html => qr/Dog/),
  'chinese zodiac animal for 1939' => test_zci('Rabbit', html => qr/Rabbit/),
  'chinese zodiac animal for 1944' => test_zci('Monkey', html => qr/Monkey/),
  'chinese zodiac animal for 1949' => test_zci('Ox', html => qr/Ox/),
  'chinese zodiac animal for 1954' => test_zci('Horse', html => qr/Horse/),
  'chinese zodiac animal for 1959' => test_zci('Pig', html => qr/Pig/),
  'chinese zodiac animal for 1964' => test_zci('Dragon', html => qr/Dragon/),
  'chinese zodiac animal for 1969' => test_zci('Rooster', html => qr/Rooster/),
  'chinese zodiac animal for 1974' => test_zci('Tiger', html => qr/Tiger/),
  'chinese zodiac animal for 2027' => test_zci('Goat', html => qr/Goat/),
  'chinese zodiac animal for 2040' => test_zci('Monkey', html => qr/Monkey/),

  #Test for correct date ranges
  # Taken from http://www.chinesezodiac.com/calculator.php
  'chinese zodiac animal for 1925' => test_zci('Ox', html => qr/Jan\s24,\s1925.Feb\s12,\s1926/),
  'chinese zodiac animal for 1937' => test_zci('Ox', html => qr/Feb\s11,\s1937.Jan\s30,\s1938/),
  'chinese zodiac animal for 1953' => test_zci('Snake', html => qr/Feb\s14,\s1953.Feb\s2,\s1954/),
  'chinese zodiac animal for 1973' => test_zci('Ox', html => qr/Feb\s3,\s1973.Jan\s22,\s1974/),
  'chinese zodiac animal for 1997' => test_zci('Ox', html => qr/Feb\s7,\s1997.Jan\s27,\s1998/),
  'chinese zodiac animal for 2013' => test_zci('Snake', html => qr/Feb\s10,\s2013.Jan\s30,\s2014/),
  'chinese zodiac animal for 2017' => test_zci('Rooster', html => qr/Jan\s28,\s2017.Feb\s15,\s2018/),
  'chinese zodiac animal for 2041' => test_zci('Rooster', html => qr/Feb\s1,\s2041.Jan\s21,\s2042/),

  #Should not trigger
  'wikipedia chinese zodiac' => undef,
  'what is my zodiac sign' => undef,
  'what is the chinese word for duck' => undef,
  'buy an inflatable zodiac chinese online store' => undef,
  'chinese zodiac 20 march 1997' => undef,
  'chinese zodiac 1997-03-20' => undef,
  'what was the chinese zodiac animal on the 3rd of april 1945' => undef,

  #No support currently for years outside 1900--2069
  'chinese zodiac 1899' => undef,
  'chinese zodiac 1900' => test_zci('Rat', html => qr/Rat/),
  'chinese zodiac 2069' => test_zci('Ox', html => qr/Ox/),
  'chinese zodiac 2070' => undef,
  'chinese zodiac 2000000000000' => undef,

);

done_testing;

