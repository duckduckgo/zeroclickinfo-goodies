#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Goodie::Calculator;    # For function subtests.

zci answer_type => 'calc';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Calculator )],
    'what is 2-2' => test_zci(
        "2 - 2 = 0",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'solve 2+2' => test_zci(
        "2 + 2 = 4",
        heading => 'Calculator',
        html    => qr/./,
    ),
    '2^8' => test_zci(
        "2 ^ 8 = 256",
        heading => 'Calculator',
        html    => qr/./,
    ),
    '2 *7' => test_zci(
        "2 * 7 = 14",
        heading => 'Calculator',
        html    => qr/./,
    ),
    '1 dozen * 2' => test_zci(
        "1 dozen * 2 = 24",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'dozen + dozen' => test_zci(
        "dozen + dozen = 24",
        heading => 'Calculator',
        html    => qr/./,
    ),
    '2divided by 4' => test_zci(
        "2 divided by 4 = 0.5",
        heading => 'Calculator',
        html    => qr/./,
    ),
    '2^dozen' => test_zci(
        "2 ^ dozen = 4,096",
        heading => 'Calculator',
        html    => qr/./,
    ),
    '2^2' => test_zci(
        "2 ^ 2 = 4",
        heading => 'Calculator',
        html    => qr/./,
    ),
    '2^0.2' => test_zci(
        "2 ^ 0.2 = 1.14869835499704",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'cos(0)' => test_zci(
        "cos(0) = 1",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'tan(1)' => test_zci(
        "tan(1) = 1.5574077246549",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'tanh(1)' => test_zci(
        "tanh(1) = 0.761594155955765",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'cotan(1)' => test_zci(
        "cotan(1) = 0.642092615934331",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'sin(1)' => test_zci(
        "sin(1) = 0.841470984807897",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'csc(1)' => test_zci(
        "csc(1) = 1.18839510577812",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'sec(1)' => test_zci(
        "sec(1) = 1.85081571768093",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'log(3)' => test_zci(
        "log(3) = 1.09861228866811",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'ln(3)' => test_zci(
        "ln(3) = 1.09861228866811",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'log10(100.00)' => test_zci(
        "log10(100.00) = 2",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'log_10(100.00)' => test_zci(
        "log_10(100.00) = 2",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'log_2(16)' => test_zci(
        "log_2(16) = 4",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'log_23(25)' => test_zci(
        "log_23(25) = 1.0265928122321",
        heading => 'Calculator',
        html    => qr/./,
    ),
    'log23(25)' => test_zci(
        "log23(25) = 1.0265928122321",
        heading => 'Calculator',
        html    => qr/./,
    ),
    '$3.43+$34.45' => test_zci(
        '$3.43 + $34.45 = $37.88',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '$3.45+$34.45' => test_zci(
        '$3.45 + $34.45 = $37.90',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '$3+$34' => test_zci(
        '$3 + $34 = $37',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '$3,4+$34,4' => test_zci(
        '$3,4 + $34,4 = $37,8',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '64*343' => test_zci(
        '64 * 343 = 21,952',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '1E2 + 1' => test_zci(
        '(1  *  10 ^ 2) + 1 = 101',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '1 + 1E2' => test_zci(
        '1 + (1  *  10 ^ 2) = 101',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '2 * 3 + 1E2' => test_zci(
        '2 * 3 + (1  *  10 ^ 2) = 106',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '1E2 + 2 * 3' => test_zci(
        '(1  *  10 ^ 2) + 2 * 3 = 106',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '1E2 / 2' => test_zci(
        '(1  *  10 ^ 2) / 2 = 50',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '2 / 1E2' => test_zci(
        '2 / (1  *  10 ^ 2) = 0.02',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '424334+2253828' => test_zci(
        '424334 + 2253828 = 2,678,162',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '4.243,34+22.538,28' => test_zci(
        '4.243,34 + 22.538,28 = 26.781,62',
        heading => 'Calculator',
        html    => qr/./,
    ),
    'sin(1,0) + 1,05' => test_zci(
        'sin(1,0) + 1,05 = 1,8914709848079',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '21 + 15 x 0 + 5' => test_zci(
        '21 + 15 x 0 + 5 = 26',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '0.8158 - 0.8157' => test_zci(
        '0.8158 - 0.8157 = 0.0001',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '2,90 + 4,6' => test_zci(
        '2,90 + 4,6 = 7,50',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '2,90 + sec(4,6)' => test_zci(
        '2,90 + sec(4,6) = -6,01642861135959',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '100 - 96.54' => test_zci(
        '100 - 96.54 = 3.46',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '1. + 1.' => test_zci(
        '1. + 1. = 2',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '1 + sin(pi)' => test_zci(
        '1 + sin(pi) = 1',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '1 - 1' => test_zci(
        '1 - 1 = 0',
        heading => 'Calculator',
        html    => qr/./,
    ),
    'sin(pi/2)' => test_zci(
        'sin(pi / 2) = 1',
        heading => 'Calculator',
        html    => qr/./,
    ),
    'sin(pi)' => test_zci(
        'sin(pi) = 0',
        heading => 'Calculator',
        html    => qr/./,
    ),
    'cos(2pi)' => test_zci(
        'cos(2 pi) = 1',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '5 squared' => test_zci(
        '5 squared = 25',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '1.0 + 5 squared' => test_zci(
        '1.0 + 5 squared = 26.0',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '3 squared + 4 squared' => test_zci(
        '3 squared + 4 squared = 25',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '2,2 squared' => test_zci(
        '2,2 squared = 4,8',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '0.8^2 + 0.6^2' => test_zci(
        '0.8 ^ 2 + 0.6 ^ 2 = 1',
        heading => 'Calculator',
        html    => qr#0.8<sup>2</sup> \+ 0.6<sup>2</sup><span class='text--secondary'> = #,
    ),
    '2 squared ^ 3' => test_zci(
        '2 squared ^ 3 = 256',
        heading => 'Calculator',
        html    => qr#2 squared<sup>3</sup><span class='text--secondary'> = #,
    ),
    '2 squared ^ 3.06' => test_zci(
        '2 squared ^ 3.06 = 323.972172143725',
        heading => 'Calculator',
        html    => qr#2 squared<sup>3\.06</sup><span class='text--secondary'> = #,
    ),
    '2^3 squared' => test_zci(
        '2 ^ 3 squared = 512',
        heading => 'Calculator',
        html    => qr#2<sup>3</sup>squared<span class='text--secondary'> = #,
    ),
    '4 score + 7' => test_zci(
        '4 score + 7 = 87',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '418.1 / 2' => test_zci(
        '418.1 / 2 = 209.05',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '418.005 / 8' => test_zci(
        '418.005 / 8 = 52.250625',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '(pi^4+pi^5)^(1/6)' => test_zci(
        '(pi ^ 4 + pi ^ 5) ^ (1 / 6) = 2.71828180861191',
        heading => 'Calculator',
        html    => qr#\(pi<sup>4</sup> \+ pi<sup>5</sup>\)<sup>\(1 / 6\)</sup><span class='text--secondary'> =#,
    ),
    '(pi^4+pi^5)^(1/6)+1' => test_zci(
        '(pi ^ 4 + pi ^ 5) ^ (1 / 6) + 1 = 3.71828180861191',
        heading => 'Calculator',
        html    => qr#\(pi<sup>4</sup> \+ pi<sup>5</sup>\)<sup>\(1 / 6\)</sup> \+ 1<span class='text--secondary'> =#,
    ),
    '(pi^4.1^(5-4)+pi^(5-(4^2 -8)))^(1/6)+1' => test_zci(
        '(pi ^ 4.1 ^ (5 - 4) + pi ^ (5 - (4 ^ 2 - 8))) ^ (1 / 6) + 1 = 3.18645452799383',
        heading => 'Calculator',
        html =>
          qr#\(pi<sup>4.1<sup>\(5 - 4\)</sup></sup> \+ pi<sup>\(5 - \(4<sup>2</sup> - 8\)\)</sup>\)<sup>\(1 / 6\)</sup> \+ 1<span class='text--secondary'> =#,
    ),
    '5^4^(3-2)^1' => test_zci(
        '5 ^ 4 ^ (3 - 2) ^ 1 = 625',
        heading => 'Calculator',
        html    => qr#5<sup>4<sup>\(3 - 2\)<sup>1</sup></sup></sup><span class='text--secondary'> =#,
    ),
    '(5-4)^(3-2)^1' => test_zci(
        '(5 - 4) ^ (3 - 2) ^ 1 = 1',
        heading => 'Calculator',
        html    => qr#\(5 - 4\)<sup>\(3 - 2\)<sup>1</sup></sup><span class='text--secondary'> =#,
    ),
    '(5+4-3)^(2-1)' => test_zci(
        '(5 + 4 - 3) ^ (2 - 1) = 6',
        heading => 'Calculator',
        html    => qr#\(5 \+ 4 - 3\)<sup>\(2 - 1\)</sup><span class='text--secondary'> =#,
    ),
    '5^((4-3)*(2+1))+6' => test_zci(
        '5 ^ ((4 - 3) * (2 + 1)) + 6 = 131',
        heading => 'Calculator',
        html    => qr#5<sup>\(\(4 - 3\) \* \(2 \+ 1\)\)</sup> \+ 6<span class='text--secondary'> =#,
    ),
    '20x07' => test_zci(
        '20 x 07 = 140',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '83.166.167.160/33' => test_zci(
        '83.166.167.160 / 33 = 2.520.186.883,63636',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '123.123.123.123/255.255.255.256' => test_zci(
        '123.123.123.123 / 255.255.255.256 = 0,482352941174581',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '4E5 +1 ' => test_zci(
        '(4  *  10 ^ 5) + 1 = 400,001',
        heading => 'Calculator',
        html    => qr/./,
    ),
    '4e5 +1 ' => test_zci(
        '(4  *  10 ^ 5) + 1 = 400,001',
        heading => 'Calculator',
        html    => qr/./,
    ),
    'pi/1e9' => test_zci(
        'pi / (1  *  10 ^ 9) = 3.14159265358979 * 10^-9',
        heading => 'Calculator',
        html    => qr/./,
    ),
    'pi*1e9' => test_zci(
        'pi * (1  *  10 ^ 9) = 3,141,592,653.58979',
        heading => 'Calculator',
        html    => qr/./,
    ),

    '123.123.123.123/255.255.255.255' => undef,
    '83.166.167.160/27'               => undef,
    '9 + 0 x 07'                      => undef,
    '0x07'                            => undef,
    'sin(1.0) + 1,05'                 => undef,
    '4,24,334+22,53,828'              => undef,
    '5234534.34.54+1'                 => undef,
    '//'                              => undef,
    dividedbydividedby                => undef,
    time                              => undef,    # We eval perl directly, only do whitelisted stuff!
    'four squared'                    => undef,
    '! + 1'                           => undef,    # Regression test for bad query trigger.
);

done_testing;
