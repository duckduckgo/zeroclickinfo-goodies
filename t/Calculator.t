#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Goodie::Calculator;    # For function subtests.

zci answer_type => 'calc';
zci is_cached   => 1;

subtest 'display format selection' => sub {
    my $ds_name = 'DDG::Goodie::Calculator::display_style';
    my $ds      = \&$ds_name;

    is($ds->('4,431',      '4.321')->{id}, 'perl', '4,431 and 4.321 is perl');
    is($ds->('4,431',      '4.32')->{id},  'perl', '4,431 and 4.32 is perl');
    is($ds->('4,431',      '4,32')->{id},  'euro', '4,431 and 4,32 is euro');
    is($ds->('4534,345.0', '1',)->{id},    'perl', '4534,345.0 should have another comma, not enforced; call it perl.');
    is($ds->('4,431', '4,32', '5,42')->{id}, 'euro', '4,431 and 4,32 and 5,42 is nicely euro-style');
    is($ds->('4,431', '4.32', '5.42')->{id}, 'perl', '4,431 and 4.32 and 5.42 is nicely perl-style');

    is($ds->('5234534.34.54', '1',), undef, '5234534.34.54 and 1 has a mal-formed number, so we cannot proceed');
    is($ds->('4,431', '4,32',     '4.32'), undef, '4,431 and 4,32 and 4.32 is confusingly ambig; no style');
    is($ds->('4,431', '4.32.10',  '5.42'), undef, '4,431 and 4.32.10 is hard to figure; no style');
    is($ds->('4,431', '4,32,100', '5.42'), undef, '4,431 and 4,32,100 and 5.42 has a mal-formed number, so no go.');
    is($ds->('4,431', '4,32,100', '5,42'), undef, '4,431 and 4,32,100 and 5,42 is too crazy to work out; no style');
};

ddg_goodie_test(
    [qw( DDG::Goodie::Calculator )],
    'what is 2-2' => test_zci(
        "2 - 2 = 0",
        heading => 'Calculator',
        html    => qq(<div>2 - 2 = <a href="javascript:;" onClick="document.x.q.value='0';document.x.q.focus();">0</a></div>)
    ),
    'solve 2+2' => test_zci(
        "2 + 2 = 4",
        heading => 'Calculator',
        html    => qq(<div>2 + 2 = <a href="javascript:;" onClick="document.x.q.value='4';document.x.q.focus();">4</a></div>)
    ),
    '2^8' => test_zci(
        "2 ^ 8 = 256",
        heading => 'Calculator',
        html    => qq(<div>2<sup>8</sup> = <a href="javascript:;" onClick="document.x.q.value='256';document.x.q.focus();">256</a></div>)
    ),
    '2 *7' => test_zci(
        "2 * 7 = 14",
        heading => 'Calculator',
        html    => qq(<div>2 * 7 = <a href="javascript:;" onClick="document.x.q.value='14';document.x.q.focus();">14</a></div>)
    ),
    '1 dozen * 2' => test_zci(
        "1 dozen * 2 = 24",
        heading => 'Calculator',
        html    => qq(<div>1 dozen * 2 = <a href="javascript:;" onClick="document.x.q.value='24';document.x.q.focus();">24</a></div>)
    ),
    'dozen + dozen' => test_zci(
        "dozen + dozen = 24",
        heading => 'Calculator',
        html    => qq(<div>dozen + dozen = <a href="javascript:;" onClick="document.x.q.value='24';document.x.q.focus();">24</a></div>)
    ),
    '2divided by 4' => test_zci(
        "2 divided by 4 = 0.5",
        heading => 'Calculator',
        html    => qq(<div>2 divided by 4 = <a href="javascript:;" onClick="document.x.q.value='0.5';document.x.q.focus();">0.5</a></div>)
    ),
    '2^dozen' => test_zci(
        "2 ^ dozen = 4,096",
        heading => 'Calculator',
        html    => qq(<div>2<sup>dozen</sup> = <a href="javascript:;" onClick="document.x.q.value='4,096';document.x.q.focus();">4,096</a></div>)
    ),
    '2^2' => test_zci(
        "2 ^ 2 = 4",
        heading => 'Calculator',
        html    => qq(<div>2<sup>2</sup> = <a href="javascript:;" onClick="document.x.q.value='4';document.x.q.focus();">4</a></div>)
    ),
    '2^0.2' => test_zci(
        "2 ^ 0.2 = 1.14869835499704",
        heading => 'Calculator',
        html =>
          qq(<div>2<sup>0.2</sup> = <a href="javascript:;" onClick="document.x.q.value='1.14869835499704';document.x.q.focus();">1.14869835499704</a></div>)
    ),
    'cos(0)' => test_zci(
        "cos(0) = 1",
        heading => 'Calculator',
        html    => qq(<div>cos(0) = <a href="javascript:;" onClick="document.x.q.value='1';document.x.q.focus();">1</a></div>)
    ),
    'tan(1)' => test_zci(
        "tan(1) = 1.5574077246549",
        heading => 'Calculator',
        html =>
          qq(<div>tan(1) = <a href="javascript:;" onClick="document.x.q.value='1.5574077246549';document.x.q.focus();">1.5574077246549</a></div>)
    ),
    'tanh(1)' => test_zci(
        "tanh(1) = 0.761594155955765",
        heading => 'Calculator',
        html =>
          qq(<div>tanh(1) = <a href="javascript:;" onClick="document.x.q.value='0.761594155955765';document.x.q.focus();">0.761594155955765</a></div>)
    ),
    'cotan(1)' => test_zci(
        "cotan(1) = 0.642092615934331",
        heading => 'Calculator',
        html =>
          qq(<div>cotan(1) = <a href="javascript:;" onClick="document.x.q.value='0.642092615934331';document.x.q.focus();">0.642092615934331</a></div>)
    ),
    'sin(1)' => test_zci(
        "sin(1) = 0.841470984807897",
        heading => 'Calculator',
        html =>
          qq(<div>sin(1) = <a href="javascript:;" onClick="document.x.q.value='0.841470984807897';document.x.q.focus();">0.841470984807897</a></div>)
    ),
    'csc(1)' => test_zci(
        "csc(1) = 1.18839510577812",
        heading => 'Calculator',
        html =>
          qq(<div>csc(1) = <a href="javascript:;" onClick="document.x.q.value='1.18839510577812';document.x.q.focus();">1.18839510577812</a></div>)
    ),
    'sec(1)' => test_zci(
        "sec(1) = 1.85081571768093",
        heading => 'Calculator',
        html =>
          qq(<div>sec(1) = <a href="javascript:;" onClick="document.x.q.value='1.85081571768093';document.x.q.focus();">1.85081571768093</a></div>)
    ),
    'log(3)' => test_zci(
        "log(3) = 1.09861228866811",
        heading => 'Calculator',
        html =>
          qq(<div>log(3) = <a href="javascript:;" onClick="document.x.q.value='1.09861228866811';document.x.q.focus();">1.09861228866811</a></div>)
    ),
    'ln(3)' => test_zci(
        "ln(3) = 1.09861228866811",
        heading => 'Calculator',
        html =>
          qq(<div>ln(3) = <a href="javascript:;" onClick="document.x.q.value='1.09861228866811';document.x.q.focus();">1.09861228866811</a></div>)
    ),
    'log10(100.00)' => test_zci(
        "log10(100.00) = 2",
        heading => 'Calculator',
        html    => qq(<div>log10(100.00) = <a href="javascript:;" onClick="document.x.q.value='2';document.x.q.focus();">2</a></div>)
    ),
    'log_10(100.00)' => test_zci(
        "log_10(100.00) = 2",
        heading => 'Calculator',
        html    => qq(<div>log_10(100.00) = <a href="javascript:;" onClick="document.x.q.value='2';document.x.q.focus();">2</a></div>)
    ),
    'log_2(16)' => test_zci(
        "log_2(16) = 4",
        heading => 'Calculator',
        html    => qq(<div>log_2(16) = <a href="javascript:;" onClick="document.x.q.value='4';document.x.q.focus();">4</a></div>)
    ),
    'log_23(25)' => test_zci(
        "log_23(25) = 1.0265928122321",
        heading => 'Calculator',
        html =>
          qq(<div>log_23(25) = <a href="javascript:;" onClick="document.x.q.value='1.0265928122321';document.x.q.focus();">1.0265928122321</a></div>)
    ),
    'log23(25)' => test_zci(
        "log23(25) = 1.0265928122321",
        heading => 'Calculator',
        html =>
          qq(<div>log23(25) = <a href="javascript:;" onClick="document.x.q.value='1.0265928122321';document.x.q.focus();">1.0265928122321</a></div>)
    ),
    '$3.43+$34.45' => test_zci(
        '$3.43 + $34.45 = $37.88',
        heading => 'Calculator',
        html    => qq(<div>\$3.43 + \$34.45 = <a href="javascript:;" onClick="document.x.q.value='\$37.88';document.x.q.focus();">\$37.88</a></div>)
    ),
    '$3.45+$34.45' => test_zci(
        '$3.45 + $34.45 = $37.90',
        heading => 'Calculator',
        html    => qq(<div>\$3.45 + \$34.45 = <a href="javascript:;" onClick="document.x.q.value='\$37.90';document.x.q.focus();">\$37.90</a></div>)
    ),
    '$3+$34' => test_zci(
        '$3 + $34 = $37',
        heading => 'Calculator',
        html    => qq(<div>\$3 + \$34 = <a href="javascript:;" onClick="document.x.q.value='\$37';document.x.q.focus();">\$37</a></div>)
    ),
    '$3,4+$34,4' => test_zci(
        '$3,4 + $34,4 = $37,8',
        heading => 'Calculator',
        html    => qq(<div>\$3,4 + \$34,4 = <a href="javascript:;" onClick="document.x.q.value='\$37,8';document.x.q.focus();">\$37,8</a></div>)
    ),
    '64*343' => test_zci(
        '64 * 343 = 21,952',
        heading => 'Calculator',
        html    => qq(<div>64 * 343 = <a href="javascript:;" onClick="document.x.q.value='21,952';document.x.q.focus();">21,952</a></div>),
    ),
    '1E2 + 1' => test_zci(
        '(1  *  10 ^ 2) + 1 = 101',
        heading => 'Calculator',
        html => qq(<div>(1  *  10<sup>2</sup>) + 1 = <a href="javascript:;" onClick="document.x.q.value='101';document.x.q.focus();">101</a></div>),
    ),
    '1 + 1E2' => test_zci(
        '1 + (1  *  10 ^ 2) = 101',
        heading => 'Calculator',
        html => qq(<div>1 + (1  *  10<sup>2</sup>) = <a href="javascript:;" onClick="document.x.q.value='101';document.x.q.focus();">101</a></div>),
    ),
    '2 * 3 + 1E2' => test_zci(
        '2 * 3 + (1  *  10 ^ 2) = 106',
        heading => 'Calculator',
        html =>
          qq(<div>2 * 3 + (1  *  10<sup>2</sup>) = <a href="javascript:;" onClick="document.x.q.value='106';document.x.q.focus();">106</a></div>),
    ),
    '1E2 + 2 * 3' => test_zci(
        '(1  *  10 ^ 2) + 2 * 3 = 106',
        heading => 'Calculator',
        html =>
          qq(<div>(1  *  10<sup>2</sup>) + 2 * 3 = <a href="javascript:;" onClick="document.x.q.value='106';document.x.q.focus();">106</a></div>),
    ),
    '1E2 / 2' => test_zci(
        '(1  *  10 ^ 2) / 2 = 50',
        heading => 'Calculator',
        html    => qq(<div>(1  *  10<sup>2</sup>) / 2 = <a href="javascript:;" onClick="document.x.q.value='50';document.x.q.focus();">50</a></div>),
    ),
    '2 / 1E2' => test_zci(
        '2 / (1  *  10 ^ 2) = 0.02',
        heading => 'Calculator',
        html => qq(<div>2 / (1  *  10<sup>2</sup>) = <a href="javascript:;" onClick="document.x.q.value='0.02';document.x.q.focus();">0.02</a></div>),
    ),
    '424334+2253828' => test_zci(
        '424334 + 2253828 = 2,678,162',
        heading => 'Calculator',
        html => qq(<div>424334 + 2253828 = <a href="javascript:;" onClick="document.x.q.value='2,678,162';document.x.q.focus();">2,678,162</a></div>),
    ),
    '4.243,34+22.538,28' => test_zci(
        '4.243,34 + 22.538,28 = 26.781,62',
        heading => 'Calculator',
        html =>
          qq(<div>4.243,34 + 22.538,28 = <a href="javascript:;" onClick="document.x.q.value='26.781,62';document.x.q.focus();">26.781,62</a></div>),
    ),
    'sin(1,0) + 1,05' => test_zci(
        'sin(1,0) + 1,05 = 1,8914709848079',
        heading => 'Calculator',
        html =>
          qq(<div>sin(1,0) + 1,05 = <a href="javascript:;" onClick="document.x.q.value='1,8914709848079';document.x.q.focus();">1,8914709848079</a></div>),
    ),
    '21 + 15 x 0 + 5' => test_zci(
        '21 + 15 x 0 + 5 = 26',
        heading => 'Calculator',
        html    => qq(<div>21 + 15 x 0 + 5 = <a href="javascript:;" onClick="document.x.q.value='26';document.x.q.focus();">26</a></div>),
    ),
    '0.8158 - 0.8157' => test_zci(
        '0.8158 - 0.8157 = 0.0001',
        heading => 'Calculator',
        html    => qq(<div>0.8158 - 0.8157 = <a href="javascript:;" onClick="document.x.q.value='0.0001';document.x.q.focus();">0.0001</a></div>),
    ),
    '2,90 + 4,6' => test_zci(
        '2,90 + 4,6 = 7,50',
        heading => 'Calculator',
        html    => qq(<div>2,90 + 4,6 = <a href="javascript:;" onClick="document.x.q.value='7,50';document.x.q.focus();">7,50</a></div>),
    ),
    '2,90 + sec(4,6)' => test_zci(
        '2,90 + sec(4,6) = -6,01642861135959',
        heading => 'Calculator',
        html =>
          qq(<div>2,90 + sec(4,6) = <a href="javascript:;" onClick="document.x.q.value='-6,01642861135959';document.x.q.focus();">-6,01642861135959</a></div>),
    ),
    '100 - 96.54' => test_zci(
        '100 - 96.54 = 3.46',
        heading => 'Calculator',
        html    => qq(<div>100 - 96.54 = <a href="javascript:;" onClick="document.x.q.value='3.46';document.x.q.focus();">3.46</a></div>),
    ),
    '1. + 1.' => test_zci(
        '1. + 1. = 2',
        heading => 'Calculator',
        html    => qq(<div>1. + 1. = <a href="javascript:;" onClick="document.x.q.value='2';document.x.q.focus();">2</a></div>),
    ),
    '1 + sin(pi)' => test_zci(
        '1 + sin(pi) = 1',
        heading => 'Calculator',
        html    => qq(<div>1 + sin(pi) = <a href="javascript:;" onClick="document.x.q.value='1';document.x.q.focus();">1</a></div>),
    ),
    '1 - 1' => test_zci(
        '1 - 1 = 0',
        heading => 'Calculator',
        html    => qq(<div>1 - 1 = <a href="javascript:;" onClick="document.x.q.value='0';document.x.q.focus();">0</a></div>),
    ),
    'sin(pi/2)' => test_zci(
        'sin(pi / 2) = 1',
        heading => 'Calculator',
        html    => qq(<div>sin(pi / 2) = <a href="javascript:;" onClick="document.x.q.value='1';document.x.q.focus();">1</a></div>),
    ),
    'sin(pi)' => test_zci(
        'sin(pi) = 0',
        heading => 'Calculator',
        html    => qq(<div>sin(pi) = <a href="javascript:;" onClick="document.x.q.value='0';document.x.q.focus();">0</a></div>),
    ),
    'cos(2pi)' => test_zci(
        'cos(2 pi) = 1',
        heading => 'Calculator',
        html    => qq(<div>cos(2 pi) = <a href="javascript:;" onClick="document.x.q.value='1';document.x.q.focus();">1</a></div>),
    ),
    'sin(1.0) + 1,05'    => undef,
    '4,24,334+22,53,828' => undef,
    '5234534.34.54+1'    => undef,
    '//'                 => undef,
    dividedbydividedby   => undef,
);

done_testing;
