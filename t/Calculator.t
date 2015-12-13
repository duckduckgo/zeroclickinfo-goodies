#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Goodie::Calculator;    # For function subtests.
use utf8;

zci answer_type => 'calc';
zci is_cached   => 1;

sub build_result {
    my ($result, $formatted_input) = @_;
    $formatted_input = '' unless $formatted_input;
    return $result, structured_answer => {
        id => 'calculator',
        name => 'Answer',
        data => {
            title => $result,
            subtitle => "$formatted_input = $result",
        },
        templates => {
            group => 'text',
            moreAt => 0,
        }
    };
}

sub build_test {
    my ($expected_result, $expected_input_format) = @_;
    return test_zci(build_result($expected_result, $expected_input_format));
}

ddg_goodie_test(
    [qw( DDG::Goodie::Calculator )],
    'what is 2-2' => build_test('0', '2 - 2'),
    'solve 2+2' => build_test('4', '2 + 2'),
    '2^8' => build_test('256', '2 ^ 8'),
    '2 *7' => build_test('14', '2 * 7'),
    '4 ∙ 5' => build_test('20', '4 * 5'),
    '6 ⋅ 7' => build_test('42', '6 * 7'),
    '3 × dozen' => build_test('36', '3 dozen'),
    'dozen ÷ 4' => build_test('3', 'dozen / 4'),
    '1 dozen * 2' => build_test('24', '1 * dozen * 2'),
    'dozen + dozen' => build_test('24', 'dozen + dozen'),
    '2divided by 4' => build_test('0.5', '2 divided by 4'),
    '2^2' => build_test('4', '2 ^ 2'),
    '2^0.2' => build_test('1.14869835499704', '2 ^ 0.2'),
    'cos(0)' => build_test('1', 'cos(0)'),
    'tan(1)' => build_test('1.5574077246549', 'tan(1)'),
    'tanh(1)' => build_test('0.761594155955765', 'tanh(1)'),
    'cotan(1)' => build_test('0.642092615934331', 'cotan(1)'),
    'sin(1)' => build_test('0.841470984807897', 'sin(1)'),
    'csc(1)' => build_test('1.18839510577812', 'csc(1)'),
    'sec(1)' => build_test('1.85081571768093', 'sec(1)'),
    'log(3)' => build_test('1.09861228866811', 'log(3)'),
    'ln(3)' => build_test('1.09861228866811', 'log(3)'),
    'log10(100.00)' => build_test('2', 'log10(100.00)'),
    'log_10(100.00)' => build_test('2', 'log_10(100.00)'),
    'log_2(16)' => build_test('4', 'log_2(16)'),
    'log_23(25)' => build_test('1.0265928122321', 'log_23(25)'),
    'log23(25)' => build_test('1.0265928122321', 'log23(25)'),
    '$3.43+$34.45' => build_test('$37.88', '$3.43 + $34.45'),
    '$3.45+$34.45' => build_test('$37.90', '$3.45 + $34.45'),
    '$3+$34' => build_test('$37.00', '$3 + $34'),
    '$3,4+$34,4' => build_test('$37,80', '$3,4 + $34,4'),
    '64*343' => build_test('21,952', '64 * 343'),
    '1E2 + 1' => build_test('101', '1e2 + 1'),
    '1 + 1E2' => build_test('101', '1 + 1e2'),
    '2 * 3 + 1E2' => build_test('106', '2 * 3 + 1e2'),
    '1E2 + 2 * 3' => build_test('106', '1e2 + 2 * 3'),
    '1E2 / 2' => build_test('50', '(1  *  10 ^ 2) / 2'),
    '2 / 1E2' => build_test('0.02', '2 / (1  *  10 ^ 2)'),
    '424334+2253828' => build_test('2,678,162', '424334 + 2253828'),
    '4.243,34+22.538,28' => build_test('26.781,62', '4.243,34 + 22.538,28'),
    'sin(1,0) + 1,05' => build_test('1,8914709848079', 'sin(1,0) + 1,05'),
    '21 + 15 x 0 + 5' => build_test('26', '21 + 15 * 0 + 5'),
    '0.8158 - 0.8157' => build_test('0.0001', '0.8158 - 0.8157'),
    '2,90 + 4,6' => build_test('7,50', '2,90 + 4,6'),
    '2,90 + sec(4,6)' => build_test('-6,01642861135959', '2,90 + sec(4,6)'),
    '100 - 96.54' => build_test('3.46', '100 - 96.54'),
    '1. + 1.' => build_test('2', '1. + 1.'),
    '1 + sin(pi)' => build_test('1', '1 + sin(pi)'),
    '1 - 1' => build_test('0', '1 - 1'),
    'sin(pi/2)' => build_test('1', 'sin(pi / 2)'),
    'sin(pi)' => build_test('0', 'sin(pi)'),
    'cos(2pi)' => build_test('1', 'cos(2 pi)'),
    '5 squared' => build_test('25', '5 squared'),
    'sqrt(4)' => build_test('2', 'sqrt(4)'),
    '1.0 + 5 squared' => build_test('26', '1.0 + 5 squared'),
    '3 squared + 4 squared' => build_test('25', '3 squared + 4 squared'),
    '2,2 squared' => build_test('4,84', '2,2 squared'),
    '0.8^2 + 0.6^2' => build_test('1', '0.8 ^ 2 + 0.6 ^ 2'),
    '2 squared ^ 3' => build_test('64', '2 squared ^ 3'),
    '2 squared ^ 3.06' => build_test('323.972172143725', '2 squared ^ 3.06'),
    '2^3 squared' => build_test('512', '2 ^ 3 squared'),
    'sqrt(2)' => build_test('1.4142135623731', 'sqrt(2)'),
    'sqrt(3 pi / 4 + 1) + 1' => build_test('2.83199194599549', 'sqrt(3 pi / 4 + 1) + 1'),
    '4 score + 7' => build_test('87', '4 score + 7'),
    '418.1 / 2' => build_test('209.05', '418.1 / 2'),
    '418.005 / 8' => build_test('52.250625', '418.005 / 8'),
    '(pi^4+pi^5)^(1/6)' => build_test('2.71828180861191', '(pi ^ 4 + pi ^ 5) ^ (1 / 6)'),
    '(pi^4+pi^5)^(1/6)+1' => build_test('3.71828180861191', '(pi ^ 4 + pi ^ 5) ^ (1 / 6) + 1'),
    '5^4^(3-2)^1' => build_test('625', '5 ^ 4 ^ (3 - 2) ^ 1'),
    '(5-4)^(3-2)^1' => build_test('1', '(5 - 4) ^ (3 - 2) ^ 1'),
    '(5+4-3)^(2-1)' => build_test('6', '(5 + 4 - 3) ^ (2 - 1)'),
    '5^((4-3)*(2+1))+6' => build_test('131', '5 ^ ((4 - 3) * (2 + 1)) + 6'),
    '20x07' => build_test('140', '20 * 07'),
    '83.166.167.160/33' => build_test('2.520.186.883,63636', '83.166.167.160 / 33'),
    '123.123.123.123/255.255.255.256' => build_test('0,482352941174581', '123.123.123.123 / 255.255.255.256'),
    '4E5 +1 ' => build_test('400,001', '4e5 + 1'),
    '4e5 +1 ' => build_test('400,001', '4e5 + 1'),
    '3e-2* 9 ' => build_test('0.27', '3e-2 * 9'),
    '7e-4 *8' => build_test('0.0056', '7e-4 * 8'),
    '6 * 2e-11' => build_test('1.2 * 10^-10', '6 * 2e-11'),
    '7 + 7e-7' => build_test('7.0000007', '7 + 7e-7'),
    '1 * 7 + e-7' => build_test('2.71828182845905', '1 * 7 + e - 7'),
    '7 * e- 5' => build_test('14.0279727992134', '7 * e - 5'),
    'pi/1e9' => build_test('3.14159265358979 * 10^-9', 'pi / (1  *  10 ^ 9)'),
    'pi*1e9' => build_test('3,141,592,653.58979', 'pi * (1  *  10 ^ 9)'),
    '1 234 + 5 432' => build_test('6,666', '1234 + 5432'),
    '1_234 + 5_432' => build_test('6,666', '1234 + 5432'),
    '(0.4e^(0))*cos(0)' => build_test('0.4', '(0.4e ^ (0)) * cos(0)'),
    '2pi' => build_test('6.28318530717958', '2 pi'),
    'fact(3)' => build_test('6', 'fact(3)'),
    'factorial(3)' => build_test('6', 'fact(3)'),
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
);

done_testing;
# ^/test_zciciWbuild_test(j$dT=k$pi', ?test(f(lr'j^ldt=k$p$i'),jd7j
