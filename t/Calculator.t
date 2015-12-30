#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'calculation';
zci is_cached   => 1;

sub build_result {
    my ($result, $formatted_input) = @_;
    $formatted_input = '' unless $formatted_input;
    return $result, structured_answer => {
        id => 'calculator',
        name => 'Answer',
        data => {
            title => $result,
            subtitle => "Calculate: $formatted_input",
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
    # Trigger
    'what is 2-2'   => build_test('0', '2 - 2'),
    'solve 2+2'     => build_test('4', '2 + 2'),
    # Named constants
    'dozen ÷ 4'             => build_test('3', 'dozen / 4'),
    '1 dozen * 2'           => build_test('24', '1 dozen * 2'),
    'dozen + dozen'         => build_test('24', 'dozen + dozen'),
    '4 score + 7'           => build_test('87', '4 score + 7'),
    '2pi'                   => build_test('≈ 6.28318530718', '2π'),
    '(pi^4+pi^5)^(1/6)'     => build_test('≈ 2.718281808612', '(π ^ 4 + π ^ 5) ^ (1 / 6)'),
    '(pi^4+pi^5)^(1/6)+1'   => build_test('≈ 3.718281808612', '(π ^ 4 + π ^ 5) ^ (1 / 6) + 1'),
    'pi - pi + e - e + 2.3' => build_test('23/10 = 2.3', 'π - π + e - e + 2.3'),
    '(3 e - e) - 2e'        => build_test('0', '(3e - e) - 2e'),
    # Misc
    '64*343'                      => build_test('21,952', '64 * 343'),
    '2 *7'                        => build_test('14', '2 * 7'),
    '418.1 / 2'                   => build_test('4,181/20 = 209.05', '418.1 / 2'),
    '418.005 / 8'                 => build_test('83,601/1,600 = 52.250625', '418.005 / 8'),
    '0.8158 - 0.8157'             => build_test('1/10,000 = 0.0001', '0.8158 - 0.8157'),
    '424334+2253828'              => build_test('2,678,162', '424,334 + 2,253,828'),
    '1 + 7'                       => build_test('8', '1 + 7'),
    '8 / 4',                      => build_test('2', '8 / 4'),
    '4.7 / 10',                   => build_test('47/100 = 0.47', '4.7 / 10'),
    '1 / 50',                     => build_test('0.02', '1 / 50'),
    '0.9999999999 + 0.0000000001' => build_test('1', '0.9999999999 + 0.0000000001'),
    '2 + (2 + 2) ^ 2 - 0 + 0'     => build_test('18', '2 + (2 + 2) ^ 2 - 0 + 0'),
    '3 * 4 / 12 + 3'              => build_test('4', '3 * 4 / 12 + 3'),
    '2 - 3 - 4'                   => build_test('-5', '2 - 3 - 4'),
    '2 - 3 + 4 - 7'               => build_test('-4', '2 - 3 + 4 - 7'),
    # Powers
    '10 ^ 5'               => build_test('100,000', '10 ^ 5'),
    '2 ** 10'              => build_test('1,024', '2 ^ 10'),
    '2 ** -9'              => build_test('1/512 = 0.001953125', '2 ^ -9'),
    '9 ** (1/2)'           => build_test('3', '9 ^ (1 / 2)'),
    '9 ** (-1/2)'          => build_test('1/3 ≈ 0.3333333333333', '9 ^ (-1 / 2)'),
    '16 ** 0.25'           => build_test('2', '16 ^ 0.25'),
    '25 ** -0.5'           => build_test('1/5 = 0.2', '25 ^ -0.5'),
    '2^2'                  => build_test('4', '2 ^ 2'),
    '2^0.2'                => build_test('≈ 1.148698354997', '2 ^ 0.2'),
    '2^8'                  => build_test('256', '2 ^ 8'),
    '0.8^2 + 0.6^2'        => build_test('1', '0.8 ^ 2 + 0.6 ^ 2'),
    '5^4^(3-2)^1'          => build_test('625', '5 ^ 4 ^ (3 - 2) ^ 1'),
    '5^((4-3)*(2+1))+6'    => build_test('131', '5 ^ ((4 - 3) * (2 + 1)) + 6'),
    '(5-4)^(3-2)^1'        => build_test('1', '(5 - 4) ^ (3 - 2) ^ 1'),
    '(5+4-3)^(2-1)'        => build_test('6', '(5 + 4 - 3) ^ (2 - 1)'),
    '32 ^ 0.2'             => build_test('2', '32 ^ 0.2'),
    '2 ^ 2 ^ 3'            => build_test('256', '2 ^ 2 ^ 3'),
    '2 ^ 3 * 4'            => build_test('32', '2 ^ 3 * 4'),
    '1 + 2 to the power 3' => build_test('9', '1 + 2 ^ 3'),
    '3 to the power of 3'  => build_test('27', '3 ^ 3'),
    # Logarithms
    'log(3)'         => build_test('≈ 1.098612288668', 'ln(3)'),
    'ln(3)'          => build_test('≈ 1.098612288668', 'ln(3)'),
    'log10(100.00)'  => build_test('2', 'log10(100.00)'),
    'log_10(100.00)' => build_test('2', 'log10(100.00)'),
    'log_2(16)'      => build_test('4', 'log2(16)'),
    'log_23(25)'     => build_test('≈ 1.026592812232', 'log23(25)'),
    'log23(25)'      => build_test('≈ 1.026592812232', 'log23(25)'),
    # Currency
    '$3.43+$34.45' => build_test('$37.88', '$3.43 + $34.45'),
    '$3.45+$34.45' => build_test('$37.90', '$3.45 + $34.45'),
    '$3+$34'       => build_test('$37.00', '$3.00 + $34.00'),
    '$3,4+$34,4'   => build_test('$37,80', '$3,40 + $34,40'),
    '$2 + $7'      => build_test('$9.00',  '$2.00 + $7.00'),
    '$5'           => undef,
    'solve $50'    => undef,
    # Exponential notation
    '1E2 + 1'         => build_test('101', '1e2 + 1'),
    '1 + 1E2'         => build_test('101', '1 + 1e2'),
    '2 * 3 + 1E2'     => build_test('106', '2 * 3 + 1e2'),
    '1E2 + 2 * 3'     => build_test('106', '1e2 + 2 * 3'),
    '1E2 / 2'         => build_test('50', '1e2 / 2'),
    '2 / 1E2'         => build_test('1/50 = 0.02', '2 / 1e2'),
    '4E5 +1 '         => build_test('400,001', '4e5 + 1'),
    '4e5 +1 '         => build_test('400,001', '4e5 + 1'),
    '3e-2* 9 '        => build_test('27/100 = 0.27', '3e-2 * 9'),
    '7e-4 *8'         => build_test('7/1,250 = 0.0056', '7e-4 * 8'),
    '6 * 2e-11'       => build_test('3/25,000,000,000 = 1.2 * 10^-10', '6 * 2e-11'),
    '7 + 7e-7'        => build_test('70,000,007/10,000,000 = 7.0000007', '7 + 7e-7'),
    '1 * 7 + e-7'     => build_test('≈ 2.718281828459', '1 * 7 + e - 7'),
    '7 * e- 5'        => build_test('≈ 14.02797279921', '7 * e - 5'),
    '2e-11'           => build_test('1/50,000,000,000 = 2 * 10^-11', '2e-11'),
    '21 + 15 x 0 + 5' => build_test('26', '21 + 15 * 0 + 5'),
    # NOTE: Changed from 7,50
    '2,90 + 4,6'  => build_test('15/2 = 7,5', '2,90 + 4,6'),
    '100 - 96.54' => build_test('173/50 = 3.46', '100 - 96.54'),
    '1. + 1.'     => build_test('2', '1. + 1.'),
    '1 - 1'       => build_test('0', '1 - 1'),
    # Trigonometric functions
    'sin(pi/2)'            => build_test('1', 'sin(π / 2)'),
    'sine(pi)'             => build_test('0', 'sin(π)'),
    'sin(800)'             => build_test('≈ 0.893969648197', 'sin(800)'),
    'sin(90 degrees)'      => build_test('1', 'sin(90°)'),
    'cos(60°)'             => build_test('1/2 = 0.5', 'cos(60°)'),
    'sin(pi) + sin(180°)'  => build_test('0', 'sin(π) + sin(180°)'),
    '1 + sin(pi)'          => build_test('1', '1 + sin(π)'),
    'sin(1,0) + 1,05'      => build_test('≈ 1,891470984808', 'sin(1,0) + 1,05'),
    'sin(1.0) + 1,05'      => undef,
    'sin(pi) + 1.37'       => build_test('137/100 = 1.37', 'sin(π) + 1.37'),
    'cos(2pi)'             => build_test('1', 'cos(2π)'),
    'cosine(0)'            => build_test('1', 'cos(0)'),
    'cos(pi/2)'            => build_test('0', 'cos(π / 2)'),
    '1 + (3 / cos(pi))'    => build_test('-2', '1 + (3 / cos(π))'),
    '2.6 + (1 / cos(4.6))' => build_test('≈ -6.31642861136', '2.6 + (1 / cos(4.6))'),
    '(0.4e^(0))*cos(0)'    => build_test('1', '(0.4e ^ (0)) * cos(0)'),
    'tan(1)'               => build_test('≈ 1.557407724655', 'tan(1)'),
    'tangent(pi/4)'        => build_test('1', 'tan(π / 4)'),
    'atan(tan(1))'         => build_test('1', 'arctan(tan(1))'),
    'tan(45 degrees)'      => build_test('1', 'tan(45°)'),
    'tan(pi/2)'            => undef,
    # 'tanh(1)'            => build_test('≈ 0.761594155955765', 'tanh(1)'),
    'cotan(1)'             => build_test('≈ 0.6420926159343', 'cotan(1)'),
    'cot(1)'               => build_test('≈ 0.6420926159343', 'cotan(1)'),
    'cot(135 degrees)'     => build_test('-1', 'cotan(135°)'),
    'cotangent(1)'         => build_test('≈ 0.6420926159343', 'cotan(1)'),
    'sin(1)'               => build_test('≈ 0.8414709848079', 'sin(1)'),
    'csc(1)'               => build_test('≈ 1.188395105778', 'csc(1)'),
    'cosec(1)'             => build_test('≈ 1.188395105778', 'csc(1)'),
    'csc(30°)'             => build_test('2', 'csc(30°)'),
    'cosecant(1)'          => build_test('≈ 1.188395105778', 'csc(1)'),
    'csc(0)'               => undef,
    'cosec(pi)'            => undef,
    'sec(1)'               => build_test('≈ 1.850815717681', 'sec(1)'),
    'sec(60 degrees)'      => build_test('2', 'sec(60°)'),
    'secant(1)'            => build_test('≈ 1.850815717681', 'sec(1)'),
    '2,90 + sec(4,6)'      => build_test('≈ -6,01642861136', '2,90 + sec(4,6)'),
    # Inverse trig
    'arccos(1/2) in degrees' => build_test('60°', 'arccos(1 / 2)°'),
    'arcsin(0)'              => build_test('0', 'arcsin(0)'),
    'arccos(1)'              => build_test('0', 'arccos(1)'),
    'asin(sin(800))'         => build_test('≈ 1.106126665397', 'arcsin(sin(800))'),
    # Hyperbolic functions
    'sinh(1)'                => build_test('≈ 1.175201193644', 'sinh(1)'),
    'sinh(0)'                => build_test('0', 'sinh(0)'),
    'cosh(1)'                => build_test('≈ 1.543080634815', 'cosh(1)'),
    'cosh(0)'                => build_test('1', 'cosh(0)'),
    'cos(0) + cosh(0)'       => build_test('2', 'cos(0) + cosh(0)'),
    'tanh(1)'                => build_test('≈ 0.7615941559558', 'tanh(1)'),
    'tanh(0)'                => build_test('0', 'tanh(0)'),
    'artanh(tanh(0))'        => build_test('0', 'artanh(tanh(0))'),
    'atanh(0.7615941559558)' => build_test('≈ 1', 'artanh(0.7615941559558)'),
    'arcosh(1)'              => build_test('0', 'arcosh(1)'),
    'acosh(cosh(1))'         => build_test('1', 'arcosh(cosh(1))'),
    'arsinh(0)'              => build_test('0', 'arsinh(0)'),
    'asinh(sinh(1))'         => build_test('1', 'arsinh(sinh(1))'),

    # Word functions
    '2divided by 4'         => build_test('1/2 = 0.5', '2 / 4'),
    '60 divided by 15'      => build_test('4', '60 / 15'),
    '7 divided by (3 + 4)'  => build_test('1', '7 / (3 + 4)'),
    # Modifiers
    '5 squared'             => build_test('25', '5 squared'),
    '3 squared + 4 squared' => build_test('25', '3 squared + 4 squared'),
    '2,2 squared'           => build_test('121/25 = 4,84', '2,2 squared'),
    '2 squared ^ 3'         => build_test('64', '2 squared ^ 3'),
    '2 squared ^ 3.06'      => build_test('≈ 69.55103120167', '2 squared ^ 3.06'),
    '2^3 squared'           => build_test('512', '2 ^ 3 squared'),
    '1.0 + 5 squared'       => build_test('26', '1.0 + 5 squared'),
    'sqrt(4) squared'       => build_test('4', 'sqrt(4) squared'),
    '3° + 7°'               => build_test('10°', '3° + 7°'),
    '4 degrees - 2°'        => build_test('2°', '4° - 2°'),
    '3㎭ + 3 radians'       => build_test('6 ㎭', '3 ㎭ + 3 ㎭'),
    '2 rads + 7 rad'        => build_test('9 ㎭', '2 ㎭ + 7 ㎭'),
    '2 radians + 3 degrees' => undef,
    'pi radians in degrees' => build_test('180°', 'π ㎭°'),
    '180° in radians'       => build_test('≈ 3.14159265359 ㎭', '180° ㎭'),

    # Misc functions
    'sqrt(4)'                => build_test('2', 'sqrt(4)'),
    'sqrt(2)'                => build_test('≈ 1.414213562373', 'sqrt(2)'),
    'sqrt(pi)'               => build_test('≈ 1.772453850906', 'sqrt(π)'),
    'sqrt(3 pi / 4 + 1) + 1' => build_test('≈ 2.831991945996', 'sqrt(3π / 4 + 1) + 1'),
    'floor(7.99)'            => build_test('7', 'floor(7.99)'),
    'floor(12)'              => build_test('12', 'floor(12)'),
    '1.3 + floor(1.3)'       => build_test('23/10 = 2.3', '1.3 + floor(1.3)'),
    'ceil(7.99)'             => build_test('8', 'ceil(7.99)'),
    'ceil(12)'               => build_test('12', 'ceil(12)'),
    '1.3 + ceiling(1.3)'     => build_test('33/10 = 3.3', '1.3 + ceil(1.3)'),
    'mod(7; 3)'              => build_test('1', 'mod(7; 3)'),
    'mod(100; 7)'            => build_test('2', 'mod(100; 7)'),
    'mod(mod(123;100); 12)'  => build_test('11', 'mod(mod(123; 100); 12)'),
    'mod(1.7; 1)'            => build_test('7/10 = 0.7', 'mod(1.7; 1)'),
    # Alternate Symbols
    '20x07'                           => build_test('140', '20 * 07'),
    '4 ∙ 5'                           => build_test('20', '4 * 5'),
    '6 ⋅ 7'                           => build_test('42', '6 * 7'),
    '3 × dozen'                       => build_test('36', '3 * dozen'),
    '83.166.167.160/33'               => build_test('27.722.055.720/11 ≈ 2.520.186.883,636', '83.166.167.160 / 33'),
    '123.123.123.123/255.255.255.256' => build_test('≈ 0,4823529411746', '123.123.123.123 / 255.255.255.256'),
    'pi/1e9'                          => build_test('≈ 3.14159265359 * 10^-9', 'π / 1e9'),
    'pi*1e9'                          => build_test('≈ 3,141,592,653.59', 'π * 1e9'),
    '3π + 7'                          => build_test('≈ 16.42477796077', '3π + 7'),
    'π - pi'                          => build_test('0', 'π - π'),
    # Nationalization
    '1 234 + 5 432'      => build_test('6,666', '1,234 + 5,432'),
    '1_234 + 5_432'      => build_test('6,666', '1,234 + 5,432'),
    '4.243,34+22.538,28' => build_test('1.339.081/50 = 26.781,62', '4.243,34 + 22.538,28'),
    # Factorial
    'fact(3)'      => build_test('6', 'factorial(3)'),
    'factorial(3)' => build_test('6', 'factorial(3)'),
    '5!'           => build_test('120', '5!'),
    '1 + 3!'       => build_test('7', '1 + 3!'),
    '0!'           => build_test('1', '0!'),
    '(7 - 3)!'     => build_test('24', '(7 - 3)!'),
    '2 ^ 3!'       => build_test('64', '2 ^ 3!'),
    'fact(0.3)'    => undef,
    '0.3!'         => undef,
    '-7!'          => undef,
    'fact(-7)'     => undef,
    '3!!'          => undef, # This is technically the semi-factorial
    '(3!)!'        => build_test('720', '(3!)!'),
    '1001!'        => undef, # Limited it to this.
    '30!'          => build_test('≈ 26,525,285,981,219,105,864 * 10^13', '30!'),
    '28!'          => build_test('304,888,344,611,713,860,501,504,000,000', '28!'),

    '123.123.123.123/255.255.255.255' => undef,
    '83.166.167.160/27'               => undef,
    '9 + 0 x 07'                      => undef,
    # Exponential
    'exp(1)'          => build_test('≈ 2.718281828459', 'exp(1)'),
    '1 + e x exp(0)'  => build_test('≈ 3.718281828459', '1 + e * exp(0)'),
    'exp(exp(0))'     => build_test('≈ 2.718281828459', 'exp(exp(0))'),
    'e x pi + exp(0)' => build_test('≈ 9.539734222674', 'e * π + exp(0)'),
    'e x pi'          => build_test('≈ 8.539734222674', 'e * π'),
    # Undefined values
    '1 / 0'              => undef,
    '0x07'               => undef,
    '4,24,334+22,53,828' => undef,
    '5234534.34.54+1'    => undef,
    # Malformed expressions
    '//'               => undef,
    dividedbydividedby => undef,
    # This one isn't true anymore (no direct eval of user input).
    time               => undef,    # We eval perl directly, only do whitelisted stuff!
    'four squared'     => undef,
    '! + 1'            => undef,    # Regression test for bad query trigger.
    'calculate 5'      => undef,
    '382-538-2546'     => undef,    # Calling DuckDuckGo
    # Phone numbers
    '(382) 538-2546'     => undef,
    '382-538-2546 x1234' => undef,
    '1-382-538-2546'     => undef,
    '+1-(382)-538-2546'  => undef,
    '382.538.2546'       => undef,
    '+38-2538111111'     => undef,
    '+382538-111-111'    => undef,
    '+38 2538 111-111'   => undef,
    '01780-111-111'      => undef,
    '01780-111-111x400'  => undef,
    '(01780) 111 111'    => undef,
    # Optional numbers around decimal points
    '1. * 10.1 + .9' => build_test('11', '1. * 10.1 + .9'),
    '.7 + .3'        => build_test('1', '.7 + .3'),
    '.9'             => build_test('9/10', '.9'),
    '0.625'          => build_test('5/8', '0.625'),
    ',75'            => build_test('3/4', '.75'),
    '-23.'           => undef, # No new information to be gained
);

done_testing;
