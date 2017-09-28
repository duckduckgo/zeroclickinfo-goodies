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

sub build_test
{
    my ($query_expression) = @_;
    return test_zci('', structured_answer => {
        data => {
            query => $query_expression
        },
        templates => {
            group => 'base',
            options => {
                content => 'DDH.calculator.content'
            }
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Calculator )],

    'calc' => build_test(undef),
    'calculator' => build_test(undef),
    'online calculator' => build_test(undef),
    'calculator online free' => build_test(undef),
    'free online calculator' => build_test(undef),

    'calculator 1 + 5' => build_test(
        "1 + 5"
    ),
    'what is 2-2' => build_test(
        '2 - 2'
    ),
    'solve 2+2' => build_test(
        '2 + 2'
    ),
    '2^8' => build_test(
        '2 ^ 8'
    ),
    '2 *7' => build_test(
        '2 * 7'
    ),
    '4 ∙ 5' => build_test(
        '4 * 5'
    ),
    '6 ⋅ 7' => build_test(
        '6 * 7'
    ),
    '3 × dozen' => build_test(
        '3 * dozen'
    ),
    'dozen ÷ 4' => build_test(
        'dozen / 4'
    ),
    '1 dozen * 2' => build_test(
        '1 dozen * 2'
    ),
    'dozen + dozen' => build_test(
        'dozen + dozen'
    ),
    '2divided by 4' => build_test(
        '2 ÷ 4'
    ),
    '2^2' => build_test(
        '2 ^ 2'
    ),
    '2^0.2' => build_test(
        '2 ^ 0.2'
    ),
    'cos(0)' => build_test(
        'cos(0)'
    ),
    'tan(1)' => build_test(
        'tan(1)'
    ),
    'tanh(1)' => build_test(
        'tanh(1)'
    ),
    'sin(1)' => build_test(
        'sin(1)'
    ),
    '$3.43+$34.45' => build_test(
        '$3.43 + $34.45'
    ),
    '$3.45+$34.45' => build_test(
        '$3.45 + $34.45'
    ),
    '$3+$34' => build_test(
        '$3 + $34'
    ),
    '$3,4+$34,4' => build_test(
        '$3.4 + $34.4'
    ),
    '64*343' => build_test(
        '64 * 343'
    ),
    '1E2 + 1' => build_test(
        '(1 * 10 ^ 2) + 1'
    ),
    '1 + 1E2' => build_test(
        '1 + (1 * 10 ^ 2)'
    ),
    '2 * 3 + 1E2' => build_test(
        '2 * 3 + (1 * 10 ^ 2)'
    ),
    '1E2 + 2 * 3' => build_test(
        '(1 * 10 ^ 2) + 2 * 3'
    ),
    '1E2 / 2' => build_test(
        '(1 * 10 ^ 2) / 2'
    ),
    '2 / 1E2' => build_test(
        '2 / (1 * 10 ^ 2)'
    ),
    '424334+2253828' => build_test(
        '424334 + 2253828'
    ),
    '4.243,34+22.538,28' => build_test(
        '4243.34 + 22538.28'
    ),
    'sin(1,0) + 1,05' => build_test(
        'sin(1.0) + 1.05'
    ),
    '21 + 15 x 0 + 5' => build_test(
        '21 + 15 * 0 + 5'
    ),
    '0.8158 - 0.8157' => build_test(
        '0.8158 - 0.8157'
    ),
    '2,90 + 4,6' => build_test(
        '2.90 + 4.6'
    ),
    '100 - 96.54' => build_test(
        '100 - 96.54'
    ),
    '1. + 1.' => build_test(
        '1. + 1.'
    ),
    '1 + sin(pi)' => build_test(
        '1 + sin(pi)'
    ),
    '1 - 1' => build_test(
        '1 - 1'
    ),
    'sin(pi/2)' => build_test(
        'sin(pi / 2)'
    ),
    'sin(pi)' => build_test(
        'sin(pi)'
    ),
    'cos(2pi)' => build_test(
        'cos(2 pi)'
    ),
    '5 squared' => build_test(
        '5 ^ 2',
    ),
    'sqrt(4)' => build_test(
        'sqrt(4)'
    ),
    '1.0 + 5 squared' => build_test(
        '1.0 + 5 ^ 2'
    ),
    '3 squared + 4 squared' => build_test(
        '3 ^ 2 + 4 ^ 2',
    ),
    '2,2 squared' => build_test(
        '2.2 ^ 2',
    ),
    '0.8^2 + 0.6^2' => build_test(
        '0.8 ^ 2 + 0.6 ^ 2',
    ),
    '2 squared ^ 3' => build_test(
        '2 ^ 2 ^ 3',
    ),
    '2 squared ^ 3.06' => build_test(
        '2 ^ 2 ^ 3.06'
    ),
    '2^3 squared' => build_test(
        '2 ^ 3 ^ 2'
    ),
    'sqrt(2)' => build_test(
        'sqrt(2)'
    ),
    'sqrt(3 pi / 4 + 1) + 1' => build_test(
        'sqrt(3 pi / 4 + 1) + 1'
    ),
    '4 score + 7' => build_test(
        '4 score + 7'
    ),
    '418.1 / 2' => build_test(
        '418.1 / 2'
    ),
    '418.005 / 8' => build_test(
        '418.005 / 8'
    ),
    '(pi^4+pi^5)^(1/6)' => build_test(
        '(pi ^ 4 + pi ^ 5) ^ (1 / 6)'
    ),
    '(pi^4+pi^5)^(1/6)+1' => build_test(
        '(pi ^ 4 + pi ^ 5) ^ (1 / 6) + 1'
    ),
    '5^4^(3-2)^1' => build_test(
        '5 ^ 4 ^ (3 - 2) ^ 1'
    ),
    '(5-4)^(3-2)^1' => build_test(
        '(5 - 4) ^ (3 - 2) ^ 1'
    ),
    '(5+4-3)^(2-1)' => build_test(
        '(5 + 4 - 3) ^ (2 - 1)'
    ),
    '5^((4-3)*(2+1))+6' => build_test(
        '5 ^ ((4 - 3) * (2 + 1)) + 6'
    ),
    '20x07' => build_test(
        '20 * 07'
    ),
    '83.166.167.160/33' => build_test(
        '83166167160 / 33'
    ),
    '123.123.123.123/255.255.255.256' => build_test(
        '123123123123 / 255255255256'
    ),
    '4E5 +1 ' => build_test(
        '(4 * 10 ^ 5) + 1'
    ),
    '4e5 +1 ' => build_test(
        '(4 * 10 ^ 5) + 1'
    ),
    '3e-2* 9 ' => build_test(
        '(3 * 10 ^- 2) * 9'
    ),
    '7e-4 *8' => build_test(
        '(7 * 10 ^- 4) * 8'
    ),
    '6 * 2e-11' => build_test(
        '6 * (2 * 10 ^- 11)',
    ),
    '7 + 7e-7' => build_test(
        '7 + (7 * 10 ^- 7)'
    ),
    '1 * 7 + e-7' => build_test(
        '1 * 7 + e - 7'
    ),
    '7 * e- 5' => build_test(
        '7 * e - 5'
    ),
    'pi/1e9' => build_test(
        'pi / (1 * 10 ^ 9)'
    ),
    'pi*1e9' => build_test(
        'pi * (1 * 10 ^ 9)'
    ),
    '1_234 + 5_432' => build_test(
        '1234 + 5432'
    ),
    '(0.4e^(0))*cos(0)' => build_test(
        '(0.4e ^ (0)) * cos(0)'
    ),
    '2pi' => build_test(
        '2 pi',
    ),
    '-10 * 3' => build_test(
        '-10 * 3'
    ),
    '-10x3' => build_test(
        '-10 * 3'
    ),
    '1e9' => build_test(
        '(1 * 10 ^ 9)'
    ),
    '4+50%' => build_test(
        '4 + 50%'
    ),
    '456+120%' => build_test(
        '456 + 120%'
    ),
    '3.4+6%' => build_test(
        '3.4 + 6%'
    ),
    '323.7+ 55.3%' => build_test(
        '323.7 + 55.3%'
    ),
    '577.40*5%' => build_test(
        '577.40 * 5%'
    ),
    '$577.40 *0.5%' => build_test(
        '$577.40 * 0.5%'
    ),
    '200 - 50%' => build_test(
        '200 - 50%'
    ),
    '234 / 25%' => build_test(
        '234 / 25%'
    ),
    '$123 + 10% =' => build_test(
        '$123 + 10%'
    ),
    '1.75*5% =' => build_test(
        '1.75 * 5%'
    ),
    'log(10 * 2)' => build_test(
        'log(10 * 2)'
    ),
    '1 + √25 =' => build_test(
        '1 + √25'
    ),
    '= 1 + 5' => build_test(
        '=1 + 5'
    ),
    '$10.80 + 44' => build_test(
        '$10.80 + 44'
    ),
    '5 modulo 13' => build_test(
        'mod(5,13)'
    ),
    '5 % 13 + 5' => build_test(
        'mod(5,13) + 5'
    ),
    'log(10)' => build_test(
        'log(10)'
    ),
    'log2(10)' => build_test(
        'log(10,2)'
    ),
    'log2(10) * 1234 + 2' => build_test(
        'log(10,2) * 1234 + 2'
    ),
    'log10(1)' => build_test(
        'log(1)'
    ),
    'log 1' => build_test(
        'log(1)'
    ),
    'log 88 + 2' => build_test(
        'log(88) + 2'
    ),
    'log 99 + 9 - 2 * 2' => build_test(
        'log(99) + 9 - 2 * 2'
    ),
    'log5 99 + 9 - 2 * 2' => build_test(
        'log(99,5) + 9 - 2 * 2'
    ),
    'log99 1' => build_test(
        'log(1,99)'
    ),
    'log of 3231 plus 2' => build_test(
        'log(3231) + 2'
    ),
    'log of 99 / 3' => build_test(
        'log(99) / 3'
    ),
    'factorial of 88' => build_test(
        '88!'
    ),
    'factorial 77 + 32' => build_test(
        '77! + 32'
    ),
    '8 * factorial of 77 + 32' => build_test(
        '8 * 77! + 32'
    ),
    '8 * fact of 77 + 32' => build_test(
        '8 * 77! + 32'
    ),
    '8 * fact(77) + 32' => build_test(
        '8 * 77! + 32'
    ),
    '8 * fact77 + 32' => build_test(
        '8 * 77! + 32'
    ),
    '8 * fact77 + 32' => build_test(
        '8 * 77! + 32'
    ),
    'fact(20)' => build_test(
        '20!'
    ),
    'fact 20' => build_test(
        '20!'
    ),
    '.32 * 100' => build_test(
        '.32 * 100'
    ),
    '.7 + .32' => build_test(
        '.7 + .32'
    ),

    ## Trig testing
    'tan 45' => build_test(
        'tan(45)'
    ),
    'tan 45 deg' => build_test(
        'tan(45deg)'
    ),
    'sin 12 + 1341' => build_test(
        'sin(12) + 1341'
    ),
    '88 + 12341 * 123 + tan(4)' => build_test(
        '88 + 12341 * 123 + tan(4)'
    ),
    'sin 2 + tan 3 - cos 10' => build_test(
        'sin(2) + tan(3) - cos(10)'
    ),
    '75 + sin 75 deg' => build_test(
        '75 + sin(75deg)'
    ),
    'tan(sin 88+2)' => build_test(
        'tan(sin(88) + 2)'
    ),
    'cos(103*232+22)+2' => build_test(
        'cos(103 * 232 + 22) + 2'
    ),
    'cos(103*232+22)+2' => build_test(
        'cos(103 * 232 + 22) + 2'
    ),
    'square root of 25' => build_test(
        'sqrt(25)'
    ),
    '77 * square root 25 + 2' => build_test(
        '77 * sqrt(25) + 2'
    ),
    '77 * cube rt 25 + 2' => build_test(
        '77 * cbrt(25) + 2'
    ),
    'cubic rt of 90' => build_test(
        'cbrt(90)'
    ),
    '99 cubed' => build_test(
        'cube(99)'
    ),
    '2 + cube 66 + 2' => build_test(
        '2 + cube(66) + 2'
    ),
    '16739317 / 11147731' => build_test(
        '16739317 / 11147731'
    ),

    'e2e4'                            => undef,
    'cosh(4+-)'                       => undef,
    '232 * 2 cube'                    => undef, # /cube/ can't be at end, only /cubed/
    'sine'                            => undef,
    'loge'                            => undef,
    'lne'                             => undef, # a search with high click through
    'cose'                            => undef,
    'tane'                            => undef,
    '1e+6'                            => undef,
    '7/11'                            => undef, # an ambiguity. Probably looking for US store
    'sec^2-1'                         => undef,
    '(x^2-1)*(5x^4+2x+1)'             => undef,
    '88y * 1312'                      => undef,
    '23x+3x'                          => undef,
    '3a / 8b'                         => undef,
    'tan of 88 degrees and radians'   => undef,
    'sin 88 degrees + sin 10 radians' => undef,
    '1432 / 28 2'                     => undef,
    '5 + 88 2'                        => undef,
    '14 8 - 22'                       => undef,
    'mod 45 32'                       => undef,
    '$10.80 + £44'                    => undef,
    '€10 + 10 + $.1'                  => undef,
    '€ + € + €'                       => undef,
    '$10 + £8 + 9€'                   => undef,
    '£10 + $88.8888'                  => undef,
    '€10000000000 * 3 + £0.5'         => undef,
    '1337x'                           => undef,
    '3221 +'                          => undef,
    '321 + 4433431 /'                 => undef,
    '666 + 999 x'                     => undef,
    '88 ∙'                            => undef,
    '* 100 + 10'                      => undef,
    '/10 * 1234 + 30 +'               => undef,
    'times 9000 + 1'                  => undef,
    'dividedby 1000 plus 8'           => undef,
    '233.23421.'                      => undef,
    '2x+5=45'                         => undef,
    '2+5= 23421?'                     => undef,
    '382 * 2341^22 = 310323'          => undef,
    '5 = 2 + 3'                       => undef,
    '123.123.123.123/255.255.255.255' => undef,
    '83.166.167.160/27'               => undef,
    '9 + 0 x 0xbf7'                   => undef,
    '0x07'                            => undef,
    'sin(1.0) + 1,05'                 => undef,
    '4,24,334+22,53,828'              => undef,
    '5234534.34.54+1'                 => undef,
    '//'                              => undef,
    # Remove this silly test for now
    # dividedbydividedby                => undef,
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
    'word+word'                       => undef,
    'word + word'                     => undef,
    'mxtoolbox'                       => undef,
    'fx-es'                           => undef,
    '-2'                              => undef,
    '-0'                              => undef,
    'm.box.com'                       => undef,
    'urldecode hello%20there' => undef,
    '34$+16' => undef,
    '12+5t%' => undef,
    '2002 honda civic ex rim and lug size' => undef,
    '2003 xc90 traction' => undef,
    '123netflix' => undef,
    '1337X' => undef,
    '1337X.' => undef,
    '1337X.' => undef,
    '706007X' => undef,
    'etan' => undef,
    '.exe' => undef,
    '.elxs' => undef,
    '.gif' => undef,
    'e.png' => undef,
    '(929) 665-83-03' => undef,
    '(343) 270-55-66' => undef,
    '2014 E350' => undef,
    '1994 e34' => undef,
    '1980 e30' => undef,
    ')1108278829' => undef,
    '24score' => undef,
    '24 score' => undef,
    '06026/6126' => undef,
    '7/7/2014' => undef,
    '2/3/09' => undef,
    '21/12/2012' => undef,
    '12/21/2012' => undef,
    '.7zip * 100' => undef,
    '.tar64 + 0.3' => undef,
);

done_testing;
