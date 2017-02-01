#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use DDG::Goodie::Calculator;    # For function subtests.
use utf8;

zci answer_type => 'calc';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Calculator )],
    'what is 2-2' => test_zci(
        "2 - 2 = 0",
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 - 2',
                title => '0'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'solve 2+2' => test_zci(
        "2 + 2 = 4",
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 + 2',
                title => '4'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2^8' => test_zci(
        "2 ^ 8 = 256",
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 ^ 8',
                title => '256'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2 *7' => test_zci(
        "2 * 7 = 14",
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 * 7',
                title => '14'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '4 ∙ 5' => test_zci(
        "4 * 5 = 20",
        structured_answer => {
            data => {
                subtitle => 'Calculate: 4 * 5',
                title => '20'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '6 ⋅ 7' => test_zci(
        "6 * 7 = 42",
        structured_answer => {
            data => {
                subtitle => 'Calculate: 6 * 7',
                title => '42'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '3 × dozen' => test_zci(
        "3 * dozen = 36",
        structured_answer => {
            data => {
                subtitle => 'Calculate: 3 * dozen',
                title => '36'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'dozen ÷ 4' => test_zci(
        "dozen / 4 = 3",
        structured_answer => {
            data => {
                subtitle => 'Calculate: dozen / 4',
                title => '3'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1 dozen * 2' => test_zci(
        "1 dozen * 2 = 24",
        structured_answer => {
            data => {
                subtitle => 'Calculate: 1 dozen * 2',
                title => '24'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'dozen + dozen' => test_zci(
        "dozen + dozen = 24",
        structured_answer => {
            data => {
                subtitle => 'Calculate: dozen + dozen',
                title => '24'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2divided by 4' => test_zci(
        "2 divided by 4 = 0.5",
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 divided by 4',
                title => '0.5'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2^2' => test_zci(
        "2 ^ 2 = 4",
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 ^ 2',
                title => '4'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2^0.2' => test_zci(
        "2 ^ 0.2 = 1.14869835499704",
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 ^ 0.2',
                title => '1.14869835499704'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'cos(0)' => test_zci(
        "cos(0) = 1",
        structured_answer => {
            data => {
                subtitle => 'Calculate: cos(0)',
                title => '1'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'tan(1)' => test_zci(
        "tan(1) = 1.5574077246549",
        structured_answer => {
            data => {
                subtitle => 'Calculate: tan(1)',
                title => '1.5574077246549'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'tanh(1)' => test_zci(
        "tanh(1) = 0.761594155955765",
        structured_answer => {
            data => {
                subtitle => 'Calculate: tanh(1)',
                title => '0.761594155955765'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'cotan(1)' => test_zci(
        "cotan(1) = 0.642092615934331",
        structured_answer => {
            data => {
                subtitle => 'Calculate: cotan(1)',
                title => '0.642092615934331'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'sin(1)' => test_zci(
        "sin(1) = 0.841470984807897",
        structured_answer => {
            data => {
                subtitle => 'Calculate: sin(1)',
                title => '0.841470984807897'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'csc(1)' => test_zci(
        "csc(1) = 1.18839510577812",
        structured_answer => {
            data => {
                subtitle => 'Calculate: csc(1)',
                title => '1.18839510577812'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'sec(1)' => test_zci(
        "sec(1) = 1.85081571768093",
        structured_answer => {
            data => {
                subtitle => 'Calculate: sec(1)',
                title => '1.85081571768093'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'log(3)' => test_zci(
        "log(3) = 1.09861228866811",
        structured_answer => {
            data => {
                subtitle => 'Calculate: log(3)',
                title => '1.09861228866811'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'ln(3)' => test_zci(
        "log(3) = 1.09861228866811",
        structured_answer => {
            data => {
                subtitle => 'Calculate: log(3)',
                title => '1.09861228866811'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'log10(100.00)' => test_zci(
        "log10(100.00) = 2",
        structured_answer => {
            data => {
                subtitle => 'Calculate: log10(100.00)',
                title => '2'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'log_10(100.00)' => test_zci(
        "log_10(100.00) = 2",
        structured_answer => {
            data => {
                subtitle => 'Calculate: log_10(100.00)',
                title => '2'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'log_2(16)' => test_zci(
        "log_2(16) = 4",
        structured_answer => {
            data => {
                subtitle => 'Calculate: log_2(16)',
                title => '4'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'log_23(25)' => test_zci(
        "log_23(25) = 1.0265928122321",
        structured_answer => {
            data => {
                subtitle => 'Calculate: log_23(25)',
                title => '1.0265928122321'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'log23(25)' => test_zci(
        "log23(25) = 1.0265928122321",
        structured_answer => {
            data => {
                subtitle => 'Calculate: log23(25)',
                title => '1.0265928122321'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '$3.43+$34.45' => test_zci(
        '$3.43 + $34.45 = $37.88',
        structured_answer => {
            data => {
                subtitle => 'Calculate: $3.43 + $34.45',
                title => '$37.88'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '$3.45+$34.45' => test_zci(
        '$3.45 + $34.45 = $37.90',
        structured_answer => {
            data => {
                subtitle => 'Calculate: $3.45 + $34.45',
                title => '$37.90'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '$3+$34' => test_zci(
        '$3 + $34 = $37.00',
        structured_answer => {
            data => {
                subtitle => 'Calculate: $3 + $34',
                title => '$37.00'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '$3,4+$34,4' => test_zci(
        '$3,4 + $34,4 = $37,80',
        structured_answer => {
            data => {
                subtitle => 'Calculate: $3,4 + $34,4',
                title => '$37,80'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '64*343' => test_zci(
        '64 * 343 = 21,952',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 64 * 343',
                title => '21,952'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1E2 + 1' => test_zci(
        '(1  *  10 ^ 2) + 1 = 101',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (1  *  10 ^ 2) + 1',
                title => '101'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1 + 1E2' => test_zci(
        '1 + (1  *  10 ^ 2) = 101',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 1 + (1  *  10 ^ 2)',
                title => '101'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2 * 3 + 1E2' => test_zci(
        '2 * 3 + (1  *  10 ^ 2) = 106',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 * 3 + (1  *  10 ^ 2)',
                title => '106'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1E2 + 2 * 3' => test_zci(
        '(1  *  10 ^ 2) + 2 * 3 = 106',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (1  *  10 ^ 2) + 2 * 3',
                title => '106'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1E2 / 2' => test_zci(
        '(1  *  10 ^ 2) / 2 = 50',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (1  *  10 ^ 2) / 2',
                title => '50'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2 / 1E2' => test_zci(
        '2 / (1  *  10 ^ 2) = 0.02',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 / (1  *  10 ^ 2)',
                title => '0.02'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '424334+2253828' => test_zci(
        '424334 + 2253828 = 2,678,162',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 424334 + 2253828',
                title => '2,678,162'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '4.243,34+22.538,28' => test_zci(
        '4.243,34 + 22.538,28 = 26.781,62',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 4.243,34 + 22.538,28',
                title => '26.781,62'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'sin(1,0) + 1,05' => test_zci(
        'sin(1,0) + 1,05 = 1,8914709848079',
        structured_answer => {
            data => {
                subtitle => 'Calculate: sin(1,0) + 1,05',
                title => '1,8914709848079'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '21 + 15 x 0 + 5' => test_zci(
        '21 + 15 * 0 + 5 = 26',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 21 + 15 * 0 + 5',
                title => '26'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '0.8158 - 0.8157' => test_zci(
        '0.8158 - 0.8157 = 0.0001',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 0.8158 - 0.8157',
                title => '0.0001'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2,90 + 4,6' => test_zci(
        '2,90 + 4,6 = 7,50',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2,90 + 4,6',
                title => '7,50'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2,90 + sec(4,6)' => test_zci(
        '2,90 + sec(4,6) = -6,01642861135959',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2,90 + sec(4,6)',
                title => '-6,01642861135959'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '100 - 96.54' => test_zci(
        '100 - 96.54 = 3.46',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 100 - 96.54',
                title => '3.46'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1. + 1.' => test_zci(
        '1. + 1. = 2',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 1. + 1.',
                title => '2'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1 + sin(pi)' => test_zci(
        '1 + sin(pi) = 1',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 1 + sin(pi)',
                title => '1'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1 - 1' => test_zci(
        '1 - 1 = 0',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 1 - 1',
                title => '0'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'sin(pi/2)' => test_zci(
        'sin(pi / 2) = 1',
        structured_answer => {
            data => {
                subtitle => 'Calculate: sin(pi / 2)',
                title => '1'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'sin(pi)' => test_zci(
        'sin(pi) = 0',
        structured_answer => {
            data => {
                subtitle => 'Calculate: sin(pi)',
                title => '0'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'cos(2pi)' => test_zci(
        'cos(2 pi) = 1',
        structured_answer => {
            data => {
                subtitle => 'Calculate: cos(2 pi)',
                title => '1'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '5 squared' => test_zci(
        '5 ^ 2 = 25',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 5 ^ 2',
                title => '25'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'sqrt(4)' => test_zci(
        'sqrt(4) = 2',
        structured_answer => {
            data => {
                subtitle => 'Calculate: sqrt(4)',
                title => '2'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1.0 + 5 squared' => test_zci(
        '1.0 + 5 ^ 2 = 26',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 1.0 + 5 ^ 2',
                title => '26'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '3 squared + 4 squared' => test_zci(
        '3 ^ 2 + 4 ^ 2 = 25',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 3 ^ 2 + 4 ^ 2',
                title => '25'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2,2 squared' => test_zci(
        '2,2 ^ 2 = 4,84',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2,2 ^ 2',
                title => '4,84'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '0.8^2 + 0.6^2' => test_zci(
        '0.8 ^ 2 + 0.6 ^ 2 = 1',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 0.8 ^ 2 + 0.6 ^ 2',
                title => '1'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2 squared ^ 3' => test_zci(
        '2 ^ 2 ^ 3 = 256',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 ^ 2 ^ 3',
                title => '256'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2 squared ^ 3.06' => test_zci(
        '2 ^ 2 ^ 3.06 = 323.972172143725',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 ^ 2 ^ 3.06',
                title => '323.972172143725'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2^3 squared' => test_zci(
        '2 ^ 3 ^ 2 = 512',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 ^ 3 ^ 2',
                title => '512'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'sqrt(2)' => test_zci(
        'sqrt(2) = 1.4142135623731',
        structured_answer => {
            data => {
                subtitle => 'Calculate: sqrt(2)',
                title => '1.4142135623731'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'sqrt(3 pi / 4 + 1) + 1' => test_zci(
        'sqrt(3 pi / 4 + 1) + 1 = 2.83199194599549',
        structured_answer => {
            data => {
                subtitle => 'Calculate: sqrt(3 pi / 4 + 1) + 1',
                title => '2.83199194599549'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '4 score + 7' => test_zci(
        '4 score + 7 = 87',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 4 score + 7',
                title => '87'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '418.1 / 2' => test_zci(
        '418.1 / 2 = 209.05',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 418.1 / 2',
                title => '209.05'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '418.005 / 8' => test_zci(
        '418.005 / 8 = 52.250625',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 418.005 / 8',
                title => '52.250625'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '(pi^4+pi^5)^(1/6)' => test_zci(
        '(pi ^ 4 + pi ^ 5) ^ (1 / 6) = 2.71828180861191',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (pi ^ 4 + pi ^ 5) ^ (1 / 6)',
                title => '2.71828180861191'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '(pi^4+pi^5)^(1/6)+1' => test_zci(
        '(pi ^ 4 + pi ^ 5) ^ (1 / 6) + 1 = 3.71828180861191',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (pi ^ 4 + pi ^ 5) ^ (1 / 6) + 1',
                title => '3.71828180861191'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '5^4^(3-2)^1' => test_zci(
        '5 ^ 4 ^ (3 - 2) ^ 1 = 625',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 5 ^ 4 ^ (3 - 2) ^ 1',
                title => '625'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '(5-4)^(3-2)^1' => test_zci(
        '(5 - 4) ^ (3 - 2) ^ 1 = 1',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (5 - 4) ^ (3 - 2) ^ 1',
                title => '1'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '(5+4-3)^(2-1)' => test_zci(
        '(5 + 4 - 3) ^ (2 - 1) = 6',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (5 + 4 - 3) ^ (2 - 1)',
                title => '6'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '5^((4-3)*(2+1))+6' => test_zci(
        '5 ^ ((4 - 3) * (2 + 1)) + 6 = 131',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 5 ^ ((4 - 3) * (2 + 1)) + 6',
                title => '131'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '20x07' => test_zci(
        '20 * 07 = 140',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 20 * 07',
                title => '140'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '83.166.167.160/33' => test_zci(
        '83.166.167.160 / 33 = 2.520.186.883,63636',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 83.166.167.160 / 33',
                title => '2.520.186.883,63636'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '123.123.123.123/255.255.255.256' => test_zci(
        '123.123.123.123 / 255.255.255.256 = 0,482352941174581',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 123.123.123.123 / 255.255.255.256',
                title => '0,482352941174581'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '4E5 +1 ' => test_zci(
        '(4  *  10 ^ 5) + 1 = 400,001',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (4  *  10 ^ 5) + 1',
                title => '400,001'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '4e5 +1 ' => test_zci(
        '(4  *  10 ^ 5) + 1 = 400,001',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (4  *  10 ^ 5) + 1',
                title => '400,001'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '3e-2* 9 ' => test_zci(
        '(3  *  10 ^- 2) * 9 = 0.27',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (3  *  10 ^- 2) * 9',
                title => '0.27'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '7e-4 *8' => test_zci(
        '(7  *  10 ^- 4) * 8 = 0.0056',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (7  *  10 ^- 4) * 8',
                title => '0.0056'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '6 * 2e-11' => test_zci(
        '6 * (2  *  10 ^- 11) = 1.2 * 10^-10',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 6 * (2  *  10 ^- 11)',
                title => '1.2 * 10^-10'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '7 + 7e-7' => test_zci(
        '7 + (7  *  10 ^- 7) = 7.0000007',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 7 + (7  *  10 ^- 7)',
                title => '7.0000007'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1 * 7 + e-7' => test_zci(
        '1 * 7 + e - 7 = 2.71828182845905',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 1 * 7 + e - 7',
                title => '2.71828182845905'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '7 * e- 5' => test_zci(
        '7 * e - 5 = 14.0279727992134',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 7 * e - 5',
                title => '14.0279727992134'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'pi/1e9' => test_zci(
        'pi / (1  *  10 ^ 9) = 3.14159265358979 * 10^-9',
        structured_answer => {
            data => {
                subtitle => 'Calculate: pi / (1  *  10 ^ 9)',
                title => '3.14159265358979 * 10^-9'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'pi*1e9' => test_zci(
        'pi * (1  *  10 ^ 9) = 3,141,592,653.58979',
        structured_answer => {
            data => {
                subtitle => 'Calculate: pi * (1  *  10 ^ 9)',
                title => '3,141,592,653.58979'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1 234 + 5 432' => test_zci(
        '1234 + 5432 = 6,666',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 1234 + 5432',
                title    => '6,666'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1_234 + 5_432' => test_zci(
        '1234 + 5432 = 6,666',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 1234 + 5432',
                title => '6,666'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '(0.4e^(0))*cos(0)' => test_zci(
        '(0.4e ^ (0)) * cos(0) = 0.4',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (0.4e ^ (0)) * cos(0)',
                title => '0.4'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '2pi' => test_zci(
        '2 pi = 6.28318530717958',
        structured_answer => {
            data => {
                subtitle => 'Calculate: 2 pi',
                title => '6.28318530717958'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'fact(3)' => test_zci(
        'fact(3) = 6',
        structured_answer => {
            data => {
                subtitle => 'Calculate: fact(3)',
                title => '6'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    'factorial(3)' => test_zci(
        'fact(3) = 6',
        structured_answer => {
            data => {
                subtitle => 'Calculate: fact(3)',
                title => '6'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '-10 * 3' => test_zci(
        '-10 * 3 = -30',
        structured_answer => {
            data => {
                subtitle => 'Calculate: -10 * 3',
                title => '-30'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '-10x3' => test_zci(
        '-10 * 3 = -30',
        structured_answer => {
            data => {
                subtitle => 'Calculate: -10 * 3',
                title => '-30'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '1e9' => test_zci(
        '(1  *  10 ^ 9) = 1,000,000,000',
        structured_answer => {
            data => {
                subtitle => 'Calculate: (1  *  10 ^ 9)',
                title => '1,000,000,000'
            },
            templates => {
                group => 'text'
            }
        }
    ),
    '123.123.123.123/255.255.255.255' => undef,
    '83.166.167.160/27'               => undef,
    '9 + 0 x 0xbf7'                   => undef,
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
    '382-538-2546'                    => undef,    # Calling DuckDuckGo
    '(382) 538-2546'                  => undef,
    '382-538-2546 x1234'              => undef,
    '1-382-538-2546'                  => undef,
    '+1-(382)-538-2546'               => undef,
    '382.538.2546'                    => undef,
    '+38-2538111111'                  => undef,
    '+382538-111-111'                 => undef,
    '+38 2538 111-111'                => undef,
    '01780-111-111'                   => undef,
    '01780-111-111x400'               => undef,
    '(01780) 111 111'                 => undef,
    'warn "hi"; 1 + 1'                => undef,
    'die "killed"; 1 + 3'             => undef,
    '1 + 1; die'                      => undef,
    '`ls -al /`; 3 * 4'               => undef,
    '1()'                             => undef,
    '1^()'                            => undef,
    '1^($)'                           => undef,
    '1/*-+'                           => undef,
    'http://'                         => undef,
    '1(-2)'                           => undef,
    'word+word'                       => undef,
    'word + word'                     => undef,
    'mxtoolbox'                       => undef,
    'fx-es'                           => undef,
    '-2'                              => undef,
    '-0'                              => undef,
    'm.box.com'                       => undef,
);

done_testing;
