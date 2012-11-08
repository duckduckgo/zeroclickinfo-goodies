#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "resistor_colors";
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::ResistorColors
    )],

    # Check trigger kicks in.
    "330 ohms" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), black (0), black (\x{00D7}1)", html => qr/./),
    "330 ohm" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), black (0), black (\x{00D7}1)", html => qr/./),
    "330 \x{2126}" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), black (0), black (\x{00D7}1)", html => qr/./),
    "330ohms" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), black (0), black (\x{00D7}1)", html => qr/./),
    "330ohm" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), black (0), black (\x{00D7}1)", html => qr/./),
    "330\x{2126}" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), black (0), black (\x{00D7}1)", html => qr/./),

    # Various multipliers
    "472000 ohms" => test_zci("472K\x{2126} (ohms) resistor colors: yellow (4), purple (7), red (2), orange (\x{00D7}1K)", html => qr/./),
    "400000 ohms" => test_zci("400K\x{2126} (ohms) resistor colors: yellow (4), black (0), black (0), orange (\x{00D7}1K)", html => qr/./),
    "12300 ohms" => test_zci("12.3K\x{2126} (ohms) resistor colors: brown (1), red (2), orange (3), red (\x{00D7}100)", html => qr/./),

    # Rounding
    "1.2345 ohms" => test_zci("1.23\x{2126} (ohms) resistor colors: brown (1), red (2), orange (3), silver (\x{00D7}0.01)", html => qr/./),
    "1.2355 ohms" => test_zci("1.24\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (4), silver (\x{00D7}0.01)", html => qr/./),
    "12.345 ohms" => test_zci("12.3\x{2126} (ohms) resistor colors: brown (1), red (2), orange (3), gold (\x{00D7}0.1)", html => qr/./),
    "12.355 ohms" => test_zci("12.4\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (4), gold (\x{00D7}0.1)", html => qr/./),
    "123.45 ohms" => test_zci("123\x{2126} (ohms) resistor colors: brown (1), red (2), orange (3), black (\x{00D7}1)", html => qr/./),
    "123.55 ohms" => test_zci("124\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (4), black (\x{00D7}1)", html => qr/./),
    "1234.5 ohms" => test_zci("1.23K\x{2126} (ohms) resistor colors: brown (1), red (2), orange (3), brown (\x{00D7}10)", html => qr/./),
    "1235.5 ohms" => test_zci("1.24K\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (4), brown (\x{00D7}10)", html => qr/./),
    "12345 ohms" => test_zci("12.3K\x{2126} (ohms) resistor colors: brown (1), red (2), orange (3), red (\x{00D7}100)", html => qr/./),
    "12355 ohms" => test_zci("12.4K\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (4), red (\x{00D7}100)", html => qr/./),
    "123450 ohms" => test_zci("123K\x{2126} (ohms) resistor colors: brown (1), red (2), orange (3), orange (\x{00D7}1K)", html => qr/./),
    "123550 ohms" => test_zci("124K\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (4), orange (\x{00D7}1K)", html => qr/./),
    "1234500 ohms" => test_zci("1.23M\x{2126} (ohms) resistor colors: brown (1), red (2), orange (3), yellow (\x{00D7}10K)", html => qr/./),
    "1235500 ohms" => test_zci("1.24M\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (4), yellow (\x{00D7}10K)", html => qr/./),
    "12345000 ohms" => test_zci("12.3M\x{2126} (ohms) resistor colors: brown (1), red (2), orange (3), green (\x{00D7}100K)", html => qr/./),
    "12355000 ohms" => test_zci("12.4M\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (4), green (\x{00D7}100K)", html => qr/./),
    "123450000 ohms" => test_zci("123M\x{2126} (ohms) resistor colors: brown (1), red (2), orange (3), blue (\x{00D7}1M)", html => qr/./),
    "123550000 ohms" => test_zci("124M\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (4), blue (\x{00D7}1M)", html => qr/./),
    "1234500000 ohms" => test_zci("1230M\x{2126} (ohms) resistor colors: brown (1), red (2), orange (3), purple (\x{00D7}10M)", html => qr/./),
    "1235500000 ohms" => test_zci("1240M\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (4), purple (\x{00D7}10M)", html => qr/./),

    # kilo and mega multipliers
    "27kohm" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), black (0), red (\x{00D7}100)", html => qr/./),
    "27Kohm" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), black (0), red (\x{00D7}100)", html => qr/./),
    "27 K ohm" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), black (0), red (\x{00D7}100)", html => qr/./),
    "4K2 ohm" => test_zci("4.2K\x{2126} (ohms) resistor colors: yellow (4), red (2), black (0), brown (\x{00D7}10)", html => qr/./),
    "4.2K ohm" => test_zci("4.2K\x{2126} (ohms) resistor colors: yellow (4), red (2), black (0), brown (\x{00D7}10)", html => qr/./),

    # Decimal points
    "2.9ohm" => test_zci("2.9\x{2126} (ohms) resistor colors: red (2), white (9), black (0), silver (\x{00D7}0.01)", html => qr/./),

    # Negative multipliers
    "1 ohm" => test_zci("1\x{2126} (ohm) resistor colors: brown (1), black (0), black (0), silver (\x{00D7}0.01)", html => qr/./),
    "29 ohms" => test_zci("29\x{2126} (ohms) resistor colors: red (2), white (9), black (0), gold (\x{00D7}0.1)", html => qr/./),

    # Zero special case
    "0 ohms" => test_zci("0\x{2126} (ohms) resistor colors: black (0), black (0), black (0), black (\x{00D7}1)", html => qr/./),

    # Range
    "999000M ohms" => test_zci("999000M\x{2126} (ohms) resistor colors: white (9), white (9), white (9), white (\x{00D7}1000M)", html => qr/./),
    "999500M ohms" => undef,
    "1.1 ohms" => test_zci("1.1\x{2126} (ohms) resistor colors: brown (1), brown (1), black (0), silver (\x{00D7}0.01)", html => qr/./),
    "1 ohms" => test_zci("1\x{2126} (ohm) resistor colors: brown (1), black (0), black (0), silver (\x{00D7}0.01)", html => qr/./),
    "0.9 ohms" => undef,
    "-10 ohms" => undef,

    # Don't trigger
    "343.3.3.3 ohms" => undef,
    "chicken ohms" => undef,
    "what is ohms law" => undef,
    "ohm ma darling" => undef,

    # Check the HTML. Just once.
    "1.58m ohm" => test_zci("1.58M\x{2126} (ohms) resistor colors: brown (1), green (5), gray (8), yellow (\x{00D7}10K)", html =>
          "1.58M&#x2126; (ohms) resistor colors: "
          . "<span style='display:inline-block;background-color:#964b00;"
          . "color:#fff;border:1px solid #c8c8c8;margin-top:-1px;padding:0px 4px;border-radius:4px;"
          . "-webkit-border-radius:4px;-moz-border-radius:4px;'>brown (1)</span> "
          . "<span style='display:inline-block;background-color:#9acd32;"
          . "color:#000;border:1px solid #c8c8c8;margin-top:-1px;padding:0px 4px;border-radius:4px;"
          . "-webkit-border-radius:4px;-moz-border-radius:4px;'>green (5)</span> "
          . "<span style='display:inline-block;background-color:#a0a0a0;"
          . "color:#000;border:1px solid #c8c8c8;margin-top:-1px;padding:0px 4px;border-radius:4px;"
          . "-webkit-border-radius:4px;-moz-border-radius:4px;'>gray (8)</span> "
          . "<span style='display:inline-block;background-color:#ffff00;"
          . "color:#000;border:1px solid #c8c8c8;margin-top:-1px;padding:0px 4px;border-radius:4px;"
          . "-webkit-border-radius:4px;-moz-border-radius:4px;'>yellow (&times;10K)</span>"
          . "<br/><span style='font-size:92.8%;color:#333'>Followed by a gap and tolerance color. "
          . "<a href='http://resisto.rs/#1.58M'>More at resisto.rs</a></span>"),

);

done_testing;
