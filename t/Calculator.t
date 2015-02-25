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
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 - 2'],
            operation => 'Calculate',
            result    => qr/>0</
        }
    ),
    'solve 2+2' => test_zci(
        "2 + 2 = 4",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 + 2'],
            operation => 'Calculate',
            result    => qr/>4</
        }
    ),
    '2^8' => test_zci(
        "2 ^ 8 = 256",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 ^ 8'],
            operation => 'Calculate',
            result    => qr/>256</
        }
    ),
    '2 *7' => test_zci(
        "2 * 7 = 14",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 * 7'],
            operation => 'Calculate',
            result    => qr/>14</
        }
    ),
    '1 dozen * 2' => test_zci(
        "1 dozen * 2 = 24",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['1 dozen * 2'],
            operation => 'Calculate',
            result    => qr/>24</
        }
    ),
    'dozen + dozen' => test_zci(
        "dozen + dozen = 24",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['dozen + dozen'],
            operation => 'Calculate',
            result    => qr/>24</
        }
    ),
    '2divided by 4' => test_zci(
        "2 divided by 4 = 0.5",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 divided by 4'],
            operation => 'Calculate',
            result    => qr/>0.5</
        }
    ),
    '2^2' => test_zci(
        "2 ^ 2 = 4",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 ^ 2'],
            operation => 'Calculate',
            result    => qr/>4</
        }
    ),
    '2^0.2' => test_zci(
        "2 ^ 0.2 = 1.14869835499704",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 ^ 0.2'],
            operation => 'Calculate',
            result    => qr/>1\.14869835499704</
        }
    ),
    'cos(0)' => test_zci(
        "cos(0) = 1",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['cos(0)'],
            operation => 'Calculate',
            result    => qr/>1</
        }
    ),
    'tan(1)' => test_zci(
        "tan(1) = 1.5574077246549",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['tan(1)'],
            operation => 'Calculate',
            result    => qr/>1\.5574077246549</
        }
    ),
    'tanh(1)' => test_zci(
        "tanh(1) = 0.761594155955765",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['tanh(1)'],
            operation => 'Calculate',
            result    => qr/>0\.761594155955765</
        }
    ),
    'cotan(1)' => test_zci(
        "cotan(1) = 0.642092615934331",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['cotan(1)'],
            operation => 'Calculate',
            result    => qr/>0\.642092615934331</
        }
    ),
    'sin(1)' => test_zci(
        "sin(1) = 0.841470984807897",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['sin(1)'],
            operation => 'Calculate',
            result    => qr/>0\.841470984807897</
        }
    ),
    'csc(1)' => test_zci(
        "csc(1) = 1.18839510577812",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['csc(1)'],
            operation => 'Calculate',
            result    => qr/>1\.18839510577812</
        }
    ),
    'sec(1)' => test_zci(
        "sec(1) = 1.85081571768093",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['sec(1)'],
            operation => 'Calculate',
            result    => qr/>1\.85081571768093</
        }
    ),
    'log(3)' => test_zci(
        "log(3) = 1.09861228866811",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['log(3)'],
            operation => 'Calculate',
            result    => qr/>1\.09861228866811</
        }
    ),
    'ln(3)' => test_zci(
        "log(3) = 1.09861228866811",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['log(3)'],
            operation => 'Calculate',
            result    => qr/>1\.09861228866811</
        }
    ),
    'log10(100.00)' => test_zci(
        "log10(100.00) = 2",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['log10(100.00)'],
            operation => 'Calculate',
            result    => qr/>2</
        }
    ),
    'log_10(100.00)' => test_zci(
        "log_10(100.00) = 2",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['log_10(100.00)'],
            operation => 'Calculate',
            result    => qr/>2</
        }
    ),
    'log_2(16)' => test_zci(
        "log_2(16) = 4",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['log_2(16)'],
            operation => 'Calculate',
            result    => qr/>4</
        }
    ),
    'log_23(25)' => test_zci(
        "log_23(25) = 1.0265928122321",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['log_23(25)'],
            operation => 'Calculate',
            result    => qr/>1\.0265928122321</
        }
    ),
    'log23(25)' => test_zci(
        "log23(25) = 1.0265928122321",
        heading           => 'Calculator',
        structured_answer => {
            input     => ['log23(25)'],
            operation => 'Calculate',
            result    => qr/>1\.0265928122321</
        }
    ),
    '$3.43+$34.45' => test_zci(
        '$3.43 + $34.45 = $37.88',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['$3.43 + $34.45'],
            operation => 'Calculate',
            result    => qr/>\$37\.88</
        }
    ),
    '$3.45+$34.45' => test_zci(
        '$3.45 + $34.45 = $37.90',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['$3.45 + $34.45'],
            operation => 'Calculate',
            result    => qr/>\$37\.90</
        }
    ),
    '$3+$34' => test_zci(
        '$3 + $34 = $37.00',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['$3 + $34'],
            operation => 'Calculate',
            result    => qr/>\$37\.00</
        }
    ),
    '$3,4+$34,4' => test_zci(
        '$3,4 + $34,4 = $37,80',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['$3,4 + $34,4'],
            operation => 'Calculate',
            result    => qr/>\$37,80</
        }
    ),
    '64*343' => test_zci(
        '64 * 343 = 21,952',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['64 * 343'],
            operation => 'Calculate',
            result    => qr/>21,952</
        }
    ),
    '1E2 + 1' => test_zci(
        '(1  *  10 ^ 2) + 1 = 101',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['(1  *  10 ^ 2) + 1'],
            operation => 'Calculate',
            result    => qr/>101</
        }
    ),
    '1 + 1E2' => test_zci(
        '1 + (1  *  10 ^ 2) = 101',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['1 + (1  *  10 ^ 2)'],
            operation => 'Calculate',
            result    => qr/>101</
        }
    ),
    '2 * 3 + 1E2' => test_zci(
        '2 * 3 + (1  *  10 ^ 2) = 106',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 * 3 + (1  *  10 ^ 2)'],
            operation => 'Calculate',
            result    => qr/>106</
        }
    ),
    '1E2 + 2 * 3' => test_zci(
        '(1  *  10 ^ 2) + 2 * 3 = 106',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['(1  *  10 ^ 2) + 2 * 3'],
            operation => 'Calculate',
            result    => qr/>106</
        }
    ),
    '1E2 / 2' => test_zci(
        '(1  *  10 ^ 2) / 2 = 50',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['(1  *  10 ^ 2) / 2'],
            operation => 'Calculate',
            result    => qr/>50</
        }
    ),
    '2 / 1E2' => test_zci(
        '2 / (1  *  10 ^ 2) = 0.02',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 / (1  *  10 ^ 2)'],
            operation => 'Calculate',
            result    => qr/>0\.02</
        }
    ),
    '424334+2253828' => test_zci(
        '424334 + 2253828 = 2,678,162',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['424334 + 2253828'],
            operation => 'Calculate',
            result    => qr/>2,678,162</
        }
    ),
    '4.243,34+22.538,28' => test_zci(
        '4.243,34 + 22.538,28 = 26.781,62',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['4.243,34 + 22.538,28'],
            operation => 'Calculate',
            result    => qr/>26\.781,62</
        }
    ),
    'sin(1,0) + 1,05' => test_zci(
        'sin(1,0) + 1,05 = 1,8914709848079',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['sin(1,0) + 1,05'],
            operation => 'Calculate',
            result    => qr/>1,8914709848079</
        }
    ),
    '21 + 15 x 0 + 5' => test_zci(
        '21 + 15 * 0 + 5 = 26',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['21 + 15 * 0 + 5'],
            operation => 'Calculate',
            result    => qr/>26</
        }
    ),
    '0.8158 - 0.8157' => test_zci(
        '0.8158 - 0.8157 = 0.0001',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['0.8158 - 0.8157'],
            operation => 'Calculate',
            result    => qr/>0\.0001</
        }
    ),
    '2,90 + 4,6' => test_zci(
        '2,90 + 4,6 = 7,50',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2,90 + 4,6'],
            operation => 'Calculate',
            result    => qr/>7,50</
        }
    ),
    '2,90 + sec(4,6)' => test_zci(
        '2,90 + sec(4,6) = -6,01642861135959',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2,90 + sec(4,6)'],
            operation => 'Calculate',
            result    => qr/>-6,01642861135959</
        }
    ),
    '100 - 96.54' => test_zci(
        '100 - 96.54 = 3.46',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['100 - 96.54'],
            operation => 'Calculate',
            result    => qr/>3\.46</
        }
    ),
    '1. + 1.' => test_zci(
        '1. + 1. = 2',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['1. + 1.'],
            operation => 'Calculate',
            result    => qr/>2</
        }
    ),
    '1 + sin(pi)' => test_zci(
        '1 + sin(pi) = 1',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['1 + sin(pi)'],
            operation => 'Calculate',
            result    => qr/>1</
        }
    ),
    '1 - 1' => test_zci(
        '1 - 1 = 0',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['1 - 1'],
            operation => 'Calculate',
            result    => qr/>0</
        }
    ),
    'sin(pi/2)' => test_zci(
        'sin(pi / 2) = 1',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['sin(pi / 2)'],
            operation => 'Calculate',
            result    => qr/>1</
        }
    ),
    'sin(pi)' => test_zci(
        'sin(pi) = 0',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['sin(pi)'],
            operation => 'Calculate',
            result    => qr/>0</
        }
    ),
    'cos(2pi)' => test_zci(
        'cos(2 pi) = 1',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['cos(2 pi)'],
            operation => 'Calculate',
            result    => qr/>1</
        }
    ),
    '5 squared' => test_zci(
        '5 ^ 2 = 25',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['5 ^ 2'],
            operation => 'Calculate',
            result    => qr/>25</
        }
    ),
    '1.0 + 5 squared' => test_zci(
        '1.0 + 5 ^ 2 = 26',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['1.0 + 5 ^ 2'],
            operation => 'Calculate',
            result    => qr/>26</
        }
    ),
    '3 squared + 4 squared' => test_zci(
        '3 ^ 2 + 4 ^ 2 = 25',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['3 ^ 2 + 4 ^ 2'],
            operation => 'Calculate',
            result    => qr/>25</
        }
    ),
    '2,2 squared' => test_zci(
        '2,2 ^ 2 = 4,84',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2,2 ^ 2'],
            operation => 'Calculate',
            result    => qr/>4,84</
        }
    ),
    '0.8^2 + 0.6^2' => test_zci(
        '0.8 ^ 2 + 0.6 ^ 2 = 1',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['0.8 ^ 2 + 0.6 ^ 2'],
            operation => 'Calculate',
            result    => qr/>1</,
        }
    ),
    '2 squared ^ 3' => test_zci(
        '2 ^ 2 ^ 3 = 256',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 ^ 2 ^ 3'],
            operation => 'Calculate',
            result    => qr/>256</
        }
    ),
    '2 squared ^ 3.06' => test_zci(
        '2 ^ 2 ^ 3.06 = 323.972172143725',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 ^ 2 ^ 3.06'],
            operation => 'Calculate',
            result    => qr/>323\.972172143725</
        }
    ),
    '2^3 squared' => test_zci(
        '2 ^ 3 ^ 2 = 512',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['2 ^ 3 ^ 2'],
            operation => 'Calculate',
            result    => qr/>512</
        }
    ),
    '4 score + 7' => test_zci(
        '4 score + 7 = 87',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['4 score + 7'],
            operation => 'Calculate',
            result    => qr/>87</
        }
    ),
    '418.1 / 2' => test_zci(
        '418.1 / 2 = 209.05',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['418.1 / 2'],
            operation => 'Calculate',
            result    => qr/>209\.05</
        }
    ),
    '418.005 / 8' => test_zci(
        '418.005 / 8 = 52.250625',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['418.005 / 8'],
            operation => 'Calculate',
            result    => qr/>52\.250625</
        }
    ),
    '(pi^4+pi^5)^(1/6)' => test_zci(
        '(pi ^ 4 + pi ^ 5) ^ (1 / 6) = 2.71828180861191',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['(pi ^ 4 + pi ^ 5) ^ (1 / 6)'],
            operation => 'Calculate',
            result    => qr/>2\.71828180861191</
        }
    ),
    '(pi^4+pi^5)^(1/6)+1' => test_zci(
        '(pi ^ 4 + pi ^ 5) ^ (1 / 6) + 1 = 3.71828180861191',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['(pi ^ 4 + pi ^ 5) ^ (1 / 6) + 1'],
            operation => 'Calculate',
            result    => qr/>3\.71828180861191</
        }
    ),
    '5^4^(3-2)^1' => test_zci(
        '5 ^ 4 ^ (3 - 2) ^ 1 = 625',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['5 ^ 4 ^ (3 - 2) ^ 1'],
            operation => 'Calculate',
            result    => qr/>625</
        }
    ),
    '(5-4)^(3-2)^1' => test_zci(
        '(5 - 4) ^ (3 - 2) ^ 1 = 1',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['(5 - 4) ^ (3 - 2) ^ 1'],
            operation => 'Calculate',
            result    => qr/>1</
        }
    ),
    '(5+4-3)^(2-1)' => test_zci(
        '(5 + 4 - 3) ^ (2 - 1) = 6',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['(5 + 4 - 3) ^ (2 - 1)'],
            operation => 'Calculate',
            result    => qr/>6</
        }
    ),
    '5^((4-3)*(2+1))+6' => test_zci(
        '5 ^ ((4 - 3) * (2 + 1)) + 6 = 131',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['5 ^ ((4 - 3) * (2 + 1)) + 6'],
            operation => 'Calculate',
            result    => qr/>131</
        }
    ),
    '20x07' => test_zci(
        '20 * 07 = 140',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['20 * 07'],
            operation => 'Calculate',
            result    => qr/>140</
        }
    ),
    '83.166.167.160/33' => test_zci(
        '83.166.167.160 / 33 = 2.520.186.883,63636',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['83.166.167.160 / 33'],
            operation => 'Calculate',
            result    => qr/>2\.520\.186\.883,63636</
        }
    ),
    '123.123.123.123/255.255.255.256' => test_zci(
        '123.123.123.123 / 255.255.255.256 = 0,482352941174581',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['123.123.123.123 / 255.255.255.256'],
            operation => 'Calculate',
            result    => qr/>0,482352941174581</
        }
    ),
    '4E5 +1 ' => test_zci(
        '(4  *  10 ^ 5) + 1 = 400,001',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['(4  *  10 ^ 5) + 1'],
            operation => 'Calculate',
            result    => qr/>400,001</
        }
    ),
    '4e5 +1 ' => test_zci(
        '(4  *  10 ^ 5) + 1 = 400,001',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['(4  *  10 ^ 5) + 1'],
            operation => 'Calculate',
            result    => qr/>400,001</
        }
    ),
    'pi/1e9' => test_zci(
        'pi / (1  *  10 ^ 9) = 3.14159265358979 * 10^-9',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['pi / (1  *  10 ^ 9)'],
            operation => 'Calculate',
            result    => qr/>3\.14159265358979 \* 10<sup>-9<\/sup></
        }
    ),
    'pi*1e9' => test_zci(
        'pi * (1  *  10 ^ 9) = 3,141,592,653.58979',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['pi * (1  *  10 ^ 9)'],
            operation => 'Calculate',
            result    => qr/>3,141,592,653\.58979</
        }
    ),
    '1 234 + 5 432' => test_zci(
        '1234 + 5432 = 6,666',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['1234 + 5432'],
            operation => 'Calculate',
            result    => qr/6,666/
        }
    ),
    '1_234 + 5_432' => test_zci(
        '1234 + 5432 = 6,666',
        heading           => 'Calculator',
        structured_answer => {
            input     => ['1234 + 5432'],
            operation => 'Calculate',
            result    => qr/6,666/
        }
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
    '$5'                              => undef,
    'calculate 5'                     => undef,
    'solve $50'                       => undef,
);

done_testing;
