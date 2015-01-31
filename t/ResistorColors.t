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
    "330 ohms" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330 ohm" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330 \x{2126}" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330ohms" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330ohm" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330\x{2126}" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330 ohms resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330 ohm resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330 \x{2126} resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330ohms resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330ohm resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330\x{2126} resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "330 resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),

    # Various multipliers
    "472000 ohms" => test_zci("470K\x{2126} (ohms) resistor colors: yellow (4), purple (7), yellow (\x{00D7}10K), gold (\x{00B1}5%)", html => qr/./),
    "400000 ohms" => test_zci("400K\x{2126} (ohms) resistor colors: yellow (4), black (0), yellow (\x{00D7}10K), gold (\x{00B1}5%)", html => qr/./),
    "12300 ohms" => test_zci("12K\x{2126} (ohms) resistor colors: brown (1), red (2), orange (\x{00D7}1K), gold (\x{00B1}5%)", html => qr/./),

    # Rounding
    "1.2345 ohms" => test_zci("1.2\x{2126} (ohms) resistor colors: brown (1), red (2), gold (\x{00D7}0.1), gold (\x{00B1}5%)", html => qr/./),
    "1.2555 ohms" => test_zci("1.3\x{2126} (ohms) resistor colors: brown (1), orange (3), gold (\x{00D7}0.1), gold (\x{00B1}5%)", html => qr/./),
    "12.345 ohms" => test_zci("12\x{2126} (ohms) resistor colors: brown (1), red (2), black (\x{00D7}1), gold (\x{00B1}5%)", html => qr/./),
    "12.555 ohms" => test_zci("13\x{2126} (ohms) resistor colors: brown (1), orange (3), black (\x{00D7}1), gold (\x{00B1}5%)", html => qr/./),
    "123.45 ohms" => test_zci("120\x{2126} (ohms) resistor colors: brown (1), red (2), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "125.55 ohms" => test_zci("130\x{2126} (ohms) resistor colors: brown (1), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", html => qr/./),
    "1234.5 ohms" => test_zci("1.2K\x{2126} (ohms) resistor colors: brown (1), red (2), red (\x{00D7}100), gold (\x{00B1}5%)", html => qr/./),
    "1255.5 ohms" => test_zci("1.3K\x{2126} (ohms) resistor colors: brown (1), orange (3), red (\x{00D7}100), gold (\x{00B1}5%)", html => qr/./),
    "12345 ohms" => test_zci("12K\x{2126} (ohms) resistor colors: brown (1), red (2), orange (\x{00D7}1K), gold (\x{00B1}5%)", html => qr/./),
    "12555 ohms" => test_zci("13K\x{2126} (ohms) resistor colors: brown (1), orange (3), orange (\x{00D7}1K), gold (\x{00B1}5%)", html => qr/./),
    "123450 ohms" => test_zci("120K\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (\x{00D7}10K), gold (\x{00B1}5%)", html => qr/./),
    "125550 ohms" => test_zci("130K\x{2126} (ohms) resistor colors: brown (1), orange (3), yellow (\x{00D7}10K), gold (\x{00B1}5%)", html => qr/./),
    "1234500 ohms" => test_zci("1.2M\x{2126} (ohms) resistor colors: brown (1), red (2), green (\x{00D7}100K), gold (\x{00B1}5%)", html => qr/./),
    "1255500 ohms" => test_zci("1.3M\x{2126} (ohms) resistor colors: brown (1), orange (3), green (\x{00D7}100K), gold (\x{00B1}5%)", html => qr/./),
    "12345000 ohms" => test_zci("12M\x{2126} (ohms) resistor colors: brown (1), red (2), blue (\x{00D7}1M), gold (\x{00B1}5%)", html => qr/./),
    "12555000 ohms" => test_zci("13M\x{2126} (ohms) resistor colors: brown (1), orange (3), blue (\x{00D7}1M), gold (\x{00B1}5%)", html => qr/./),
    "123450000 ohms" => test_zci("120M\x{2126} (ohms) resistor colors: brown (1), red (2), purple (\x{00D7}10M), gold (\x{00B1}5%)", html => qr/./),
    "125550000 ohms" => test_zci("130M\x{2126} (ohms) resistor colors: brown (1), orange (3), purple (\x{00D7}10M), gold (\x{00B1}5%)", html => qr/./),
    "1234500000 ohms" => test_zci("1200M\x{2126} (ohms) resistor colors: brown (1), red (2), gray (\x{00D7}100M), gold (\x{00B1}5%)", html => qr/./),
    "1255500000 ohms" => test_zci("1300M\x{2126} (ohms) resistor colors: brown (1), orange (3), gray (\x{00D7}100M), gold (\x{00B1}5%)", html => qr/./),

    # kilo and mega multipliers
    "27kohm" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", html => qr/./),
    "27Kohm" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", html => qr/./),
    "27 K ohm" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", html => qr/./),
    "4K2 ohm" => test_zci("4.2K\x{2126} (ohms) resistor colors: yellow (4), red (2), red (\x{00D7}100), gold (\x{00B1}5%)", html => qr/./),
    "4.2K ohm" => test_zci("4.2K\x{2126} (ohms) resistor colors: yellow (4), red (2), red (\x{00D7}100), gold (\x{00B1}5%)", html => qr/./),
    "27k resistor" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", html => qr/./),
    "27K resistor" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", html => qr/./),
    "27 K resistor" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", html => qr/./),
    "4K2 resistor" => test_zci("4.2K\x{2126} (ohms) resistor colors: yellow (4), red (2), red (\x{00D7}100), gold (\x{00B1}5%)", html => qr/./),
    "4.2K resistor" => test_zci("4.2K\x{2126} (ohms) resistor colors: yellow (4), red (2), red (\x{00D7}100), gold (\x{00B1}5%)", html => qr/./),

    # Decimal points
    "2.9ohm" => test_zci("2.9\x{2126} (ohms) resistor colors: red (2), white (9), gold (\x{00D7}0.1), gold (\x{00B1}5%)", html => qr/./),
    "2.9ohms resistor" => test_zci("2.9\x{2126} (ohms) resistor colors: red (2), white (9), gold (\x{00D7}0.1), gold (\x{00B1}5%)", html => qr/./),

    # Negative multipliers
    "1 ohm" => test_zci("1\x{2126} (ohm) resistor colors: brown (1), black (0), gold (\x{00D7}0.1), gold (\x{00B1}5%)", html => qr/./),
    "29 ohms" => test_zci("29\x{2126} (ohms) resistor colors: red (2), white (9), black (\x{00D7}1), gold (\x{00B1}5%)", html => qr/./),

    # Zero special case
    "0 ohms" => test_zci("0\x{2126} (ohms) resistor colors: black (0), black (0), black (\x{00D7}1), gold (\x{00B1}5%)", html => qr/./),

    # Range
    "99000M ohms" => test_zci("99000M\x{2126} (ohms) resistor colors: white (9), white (9), white (\x{00D7}1000M), gold (\x{00B1}5%)", html => qr/./),
    "99500M ohms" => undef,
    "1.1 ohms" => test_zci("1.1\x{2126} (ohms) resistor colors: brown (1), brown (1), gold (\x{00D7}0.1), gold (\x{00B1}5%)", html => qr/./),
    "1 ohms" => test_zci("1\x{2126} (ohm) resistor colors: brown (1), black (0), gold (\x{00D7}0.1), gold (\x{00B1}5%)", html => qr/./),
    "0.9 ohms" => undef,
    "-10 ohms" => undef,

    # Don't trigger
    "343.3.3.3 ohms" => undef,
    "chicken ohms" => undef,
    "what is ohms law" => undef,
    "ohm ma darling" => undef,

    # Check the HTML. Just once.
    "4.7k ohm" => test_zci(
        "4.7K\x{2126} (ohms) resistor colors: yellow (4), purple (7), red (\x{00D7}100), gold (\x{00B1}5%)",
        html => "<div class='zci--resistor-colors'><h3 class='zci__header'>4.7K\x{2126}</h3><h4 class='zci__subheader'>Four Bands</h4><div class='zci__content'><span class='resistor-band yellow'>Yellow 4</span><span class='resistor-band purple'>Purple 7</span><span class='resistor-band red'>Red &times;100</span><span class='resistor-band gold'>Gold &plusmn;5%</span></div></div><br/><a href='http://resisto.rs/#4.7K' class='zci__more-at'>More at resisto.rs</a>"
    ),
);

done_testing;
