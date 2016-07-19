#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "resistor_colors";
zci is_cached => 1;

my $data =  {
            title => '4.7K\x{2126}',
            subtitle => 'Four Bands',
            resistor_bands => {
                {class => 'yellow', name => 'Yellow', html_prefix => '' ,display_digit => '4'},
                {class => 'purple', name => 'Purple', html_prefix => '' ,display_digit => '7'},
                {class => 'red', name => 'Red', html_prefix => '\x{00D7}' ,display_digit => '100'},
                {class => 'gold', name => 'Gold', html_prefix => '\x{00B1}' ,display_digit => '5%'}
            },
            formatted_value => '4.7K'
        };

    
sub test_structured_answer {
    my %basic_answer = get_structured_answer($_[0]);
    delete($basic_answer{data});
    $basic_answer{data} = \$data;
    return %basic_answer;
}

sub get_structured_answer {
    my %basic_answer = (
        structured_answer => {
            meta => {
                sourceName => "resisto.rs",
                sourceUrl => "http://resisto.rs/#" . $_[0]
            },
            data => ignore(),
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.resistor_colors.content',
                    moreAt => 1
                }
            }
        }
     );
     return %basic_answer;
}

ddg_goodie_test(
    [qw(
        DDG::Goodie::ResistorColors
    )],
    # Check trigger kicks in.
    "330 ohms" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330 ohm" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330 \x{2126}" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330ohms" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330ohm" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330\x{2126}" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330 ohms resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330 ohm resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330 \x{2126} resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330ohms resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330ohm resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330\x{2126} resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),
    "330 resistor" => test_zci("330\x{2126} (ohms) resistor colors: orange (3), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('330')),

    # Various multipliers
    "472000 ohms" => test_zci("470K\x{2126} (ohms) resistor colors: yellow (4), purple (7), yellow (\x{00D7}10K), gold (\x{00B1}5%)", get_structured_answer('470K')),
    "400000 ohms" => test_zci("400K\x{2126} (ohms) resistor colors: yellow (4), black (0), yellow (\x{00D7}10K), gold (\x{00B1}5%)", get_structured_answer('400K')),
    "12300 ohms" => test_zci("12K\x{2126} (ohms) resistor colors: brown (1), red (2), orange (\x{00D7}1K), gold (\x{00B1}5%)", get_structured_answer('12K')),

    # Rounding
    "1.2345 ohms" => test_zci("1.2\x{2126} (ohms) resistor colors: brown (1), red (2), gold (\x{00D7}0.1), gold (\x{00B1}5%)", get_structured_answer('1.2')),
    "1.2555 ohms" => test_zci("1.3\x{2126} (ohms) resistor colors: brown (1), orange (3), gold (\x{00D7}0.1), gold (\x{00B1}5%)", get_structured_answer('1.3')),
    "12.345 ohms" => test_zci("12\x{2126} (ohms) resistor colors: brown (1), red (2), black (\x{00D7}1), gold (\x{00B1}5%)", get_structured_answer('12')),
    "12.555 ohms" => test_zci("13\x{2126} (ohms) resistor colors: brown (1), orange (3), black (\x{00D7}1), gold (\x{00B1}5%)", get_structured_answer('13')),
    "123.45 ohms" => test_zci("120\x{2126} (ohms) resistor colors: brown (1), red (2), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('120')),
    "125.55 ohms" => test_zci("130\x{2126} (ohms) resistor colors: brown (1), orange (3), brown (\x{00D7}10), gold (\x{00B1}5%)", get_structured_answer('130')),
    "1234.5 ohms" => test_zci("1.2K\x{2126} (ohms) resistor colors: brown (1), red (2), red (\x{00D7}100), gold (\x{00B1}5%)", get_structured_answer('1.2K')),
    "1255.5 ohms" => test_zci("1.3K\x{2126} (ohms) resistor colors: brown (1), orange (3), red (\x{00D7}100), gold (\x{00B1}5%)", get_structured_answer('1.3K')),
    "12345 ohms" => test_zci("12K\x{2126} (ohms) resistor colors: brown (1), red (2), orange (\x{00D7}1K), gold (\x{00B1}5%)", get_structured_answer('12K')),
    "12555 ohms" => test_zci("13K\x{2126} (ohms) resistor colors: brown (1), orange (3), orange (\x{00D7}1K), gold (\x{00B1}5%)", get_structured_answer('13K')),
    "123450 ohms" => test_zci("120K\x{2126} (ohms) resistor colors: brown (1), red (2), yellow (\x{00D7}10K), gold (\x{00B1}5%)", get_structured_answer('120K')),
    "125550 ohms" => test_zci("130K\x{2126} (ohms) resistor colors: brown (1), orange (3), yellow (\x{00D7}10K), gold (\x{00B1}5%)", get_structured_answer('130K')),
    "1234500 ohms" => test_zci("1.2M\x{2126} (ohms) resistor colors: brown (1), red (2), green (\x{00D7}100K), gold (\x{00B1}5%)", get_structured_answer('1.2M')),
    "1255500 ohms" => test_zci("1.3M\x{2126} (ohms) resistor colors: brown (1), orange (3), green (\x{00D7}100K), gold (\x{00B1}5%)", get_structured_answer('1.3M')),
    "12345000 ohms" => test_zci("12M\x{2126} (ohms) resistor colors: brown (1), red (2), blue (\x{00D7}1M), gold (\x{00B1}5%)", get_structured_answer('12M')),
    "12555000 ohms" => test_zci("13M\x{2126} (ohms) resistor colors: brown (1), orange (3), blue (\x{00D7}1M), gold (\x{00B1}5%)", get_structured_answer('13M')),
    "123450000 ohms" => test_zci("120M\x{2126} (ohms) resistor colors: brown (1), red (2), purple (\x{00D7}10M), gold (\x{00B1}5%)", get_structured_answer('120M')),
    "125550000 ohms" => test_zci("130M\x{2126} (ohms) resistor colors: brown (1), orange (3), purple (\x{00D7}10M), gold (\x{00B1}5%)", get_structured_answer('130M')),
    "1234500000 ohms" => test_zci("1200M\x{2126} (ohms) resistor colors: brown (1), red (2), gray (\x{00D7}100M), gold (\x{00B1}5%)", get_structured_answer('1200M')),
    "1255500000 ohms" => test_zci("1300M\x{2126} (ohms) resistor colors: brown (1), orange (3), gray (\x{00D7}100M), gold (\x{00B1}5%)", get_structured_answer('1300M')),

    # kilo and mega multipliers
    "27kohm" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", get_structured_answer('27K')),
    "27Kohm" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", get_structured_answer('27K')),
    "27 K ohm" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", get_structured_answer('27K')),
    "4K2 ohm" => test_zci("4.2K\x{2126} (ohms) resistor colors: yellow (4), red (2), red (\x{00D7}100), gold (\x{00B1}5%)", get_structured_answer('4.2K')),
    "4.2K ohm" => test_zci("4.2K\x{2126} (ohms) resistor colors: yellow (4), red (2), red (\x{00D7}100), gold (\x{00B1}5%)", get_structured_answer('4.2K')),
    "27k resistor" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", get_structured_answer('27K')),
    "27K resistor" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", get_structured_answer('27K')),
    "27 K resistor" => test_zci("27K\x{2126} (ohms) resistor colors: red (2), purple (7), orange (\x{00D7}1K), gold (\x{00B1}5%)", get_structured_answer('27K')),
    "4K2 resistor" => test_zci("4.2K\x{2126} (ohms) resistor colors: yellow (4), red (2), red (\x{00D7}100), gold (\x{00B1}5%)", get_structured_answer('4.2K')),
    "4.2K resistor" => test_zci("4.2K\x{2126} (ohms) resistor colors: yellow (4), red (2), red (\x{00D7}100), gold (\x{00B1}5%)", get_structured_answer('4.2K')),

    # Decimal points
    "2.9ohm" => test_zci("2.9\x{2126} (ohms) resistor colors: red (2), white (9), gold (\x{00D7}0.1), gold (\x{00B1}5%)", get_structured_answer('2.9')),
    "2.9ohms resistor" => test_zci("2.9\x{2126} (ohms) resistor colors: red (2), white (9), gold (\x{00D7}0.1), gold (\x{00B1}5%)", get_structured_answer('2.9')),

    # Negative multipliers
    "1 ohm" => test_zci("1\x{2126} (ohm) resistor colors: brown (1), black (0), gold (\x{00D7}0.1), gold (\x{00B1}5%)", get_structured_answer('1')),
    "29 ohms" => test_zci("29\x{2126} (ohms) resistor colors: red (2), white (9), black (\x{00D7}1), gold (\x{00B1}5%)", get_structured_answer('29')),

    # Zero special case
    "0 ohms" => test_zci("0\x{2126} (ohms) resistor colors: black (0), black (0), black (\x{00D7}1), gold (\x{00B1}5%)", get_structured_answer('0')),

    # Range
    "99000M ohms" => test_zci("99000M\x{2126} (ohms) resistor colors: white (9), white (9), white (\x{00D7}1000M), gold (\x{00B1}5%)", get_structured_answer('99000M')),
    "99500M ohms" => undef,
    "1.1 ohms" => test_zci("1.1\x{2126} (ohms) resistor colors: brown (1), brown (1), gold (\x{00D7}0.1), gold (\x{00B1}5%)", get_structured_answer('1.1')),
    "1 ohms" => test_zci("1\x{2126} (ohm) resistor colors: brown (1), black (0), gold (\x{00D7}0.1), gold (\x{00B1}5%)", get_structured_answer('1')),
    "0.9 ohms" => undef,
    "-10 ohms" => undef,

    # Don't trigger
    "343.3.3.3 ohms" => undef,
    "chicken ohms" => undef,
    "what is ohms law" => undef,
    "ohm ma darling" => undef,


    # Check the content of the structured answer. Just once.
    "4.7k ohm" => test_zci(
        "4.7K\x{2126} (ohms) resistor colors: yellow (4), purple (7), red (\x{00D7}100), gold (\x{00B1}5%)",
        test_structured_answer('4.7K')
        #html => "<div class='zci--resistor-colors'><h3 class='zci__header'>4.7K\x{2126}</h3><h4 class='zci__subheader'>Four Bands</h4><div class='zci__content'><span class='resistor-band yellow'>Yellow 4</span><span class='resistor-band purple'>Purple 7</span><span class='resistor-band red'>Red &times;100</span><span class='resistor-band gold'>Gold &plusmn;5%</span></div></div><br/><a href='http://resisto.rs/#4.7K' class='zci__more-at'>More at resisto.rs</a>"
    ),
);

done_testing;
