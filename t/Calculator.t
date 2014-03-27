#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Goodie::Calculator;    # For function subtests.

zci answer_type => 'calc';
zci is_cached   => 1;

subtest 'decimal mark checker' => sub {
    my $dns_name   = 'DDG::Goodie::Calculator::determine_number_style';
    my $dns        = \&$dns_name;
    my %test_cases = (
        '4,321.00'  => 'perl',
        '4.321,00'  => 'euro',
        '4321,00'   => 'euro',
        '4,321,000' => 'perl',
        '4.321.000' => 'euro',
        '4,321'     => undef,
        '4.321'     => undef,
        '4.3210'    => 'perl',
        '4,3210'    => 'euro',
        '4.32'      => 'perl',
        '.321'      => 'perl',
        ',321'      => 'euro',
        '0.1'       => 'perl',
        '0,1'       => 'euro',
    );
    foreach my $to_test (sort keys %test_cases) {
        is($dns->($to_test), $test_cases{$to_test}, $to_test . ' looks like ' . ($test_cases{$to_test} // 'ambiguous') . ' style');
    }
};

subtest 'display format selection' => sub {
    my $dsk_name     = 'DDG::Goodie::Calculator::display_style';
    my $dsk          = \&$dsk_name;
    my %known_styles = DDG::Goodie::Calculator::known_styles();

    is_deeply($dsk->('4,431', '4.321'), $known_styles{perl}, '4,321 and 4.321 is wholly ambig; use the default style');
    is_deeply($dsk->('4,431', '4.32'),  $known_styles{perl}, '4,321 and 4.32 is perl');
    is_deeply($dsk->('4,431', '4,32'),  $known_styles{euro}, '4,321 and 4,32 is euro');
    #TODO: when display_style is used in the code, make adding the two numbers below a test case for "cannot answer"
    is_deeply($dsk->('5234534.34.54', '1',), undef, '5234534.34.54 and 1 has a mal-formed number, so we cannot proceed');
    is_deeply($dsk->('4534,345.0', '1',), $known_styles{perl}, '4534,345.0 should have another comma, not enforced; call it perl.');
    is_deeply($dsk->('4,431', '4,32',     '4.32'), undef,               '4,321 and 4,32 and 4.32 is confusingly ambig; no style');
    is_deeply($dsk->('4,431', '4,32',     '5,42'), $known_styles{euro}, '4,321 and 4,32 and 5,42 is nicely euro-style');
    is_deeply($dsk->('4,431', '4.32',     '5.42'), $known_styles{perl}, '4,321 and 4.32 and 5.42 is nicely perl-style');
    is_deeply($dsk->('4,431', '4.32.10',  '5.42'), undef,               '4,321 and 4.32.10 is hard to figure; no style');
    is_deeply($dsk->('4,431', '4,32,100', '5.42'), undef,               '4,321 and 4,32,100 and 5.42 has a mal-formed number, so no go.');
    is_deeply($dsk->('4,431', '4,32,100', '5,42'), undef,               '4,321 and 4,32,100 and 5,42 is too crazy to work out; no style');
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
    '(2c) + pi' => test_zci(
        "(2 speed of light) + pi = 599,584,919.141593",
        heading => 'Calculator',
        html =>
          qq(<div>(2 speed of light) + pi = <a href="javascript:;" onClick="document.x.q.value='599,584,919.141593';document.x.q.focus();">599,584,919.141593</a></div>)
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
    'sin(1)' => test_zci(
        "sin(1) = 0.841470984807897",
        heading => 'Calculator',
        html =>
          qq(<div>sin(1) = <a href="javascript:;" onClick="document.x.q.value='0.841470984807897';document.x.q.focus();">0.841470984807897</a></div>)
    ),
    '$3.43+$34.45' => test_zci(
        '$3.43 + $34.45 = $37.88',
        heading => 'Calculator',
        html    => qq(<div>\$3.43 + \$34.45 = <a href="javascript:;" onClick="document.x.q.value='\$37.88';document.x.q.focus();">\$37.88</a></div>)
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
    '4,24,334+22,53,828' => test_zci(
        '4,24,334 + 22,53,828 = 2,678,162',
        heading => 'Calculator',
        html =>
          qq(<div>4,24,334 + 22,53,828 = <a href="javascript:;" onClick="document.x.q.value='2,678,162';document.x.q.focus();">2,678,162</a></div>),
    ),
    '4.243,34+22.538,28' => test_zci(
        '4.243,34 + 22.538,28 = 26.781,62',
        heading => 'Calculator',
        html =>
          qq(<div>4.243,34 + 22.538,28 = <a href="javascript:;" onClick="document.x.q.value='26.781,62';document.x.q.focus();">26.781,62</a></div>),
    ),
    '//'               => undef,
    dividedbydividedby => undef,
);

done_testing;

