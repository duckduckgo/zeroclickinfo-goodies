#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'roman_numeral_conversion';
zci is_cached   => 1;

sub build_test {
    my ($text, $input, $answer) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $answer,
            subtitle => "Roman numeral conversion: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Roman )],
    'roman 155' => build_test('CLV (roman numeral conversion)', '155', 'CLV'),
    "roman xii" => build_test("12 (roman numeral conversion)", 'XII', '12'),
    "roman mmcml" => build_test("2950 (roman numeral conversion)", 'MMCML', '2950'),
    "roman 2344" => build_test("MMCCCXLIV (roman numeral conversion)", '2344', 'MMCCCXLIV'),
    "arabic cccxlvi" => build_test("346 (roman numeral conversion)", 'CCCXLVI', '346'),
    'roman numeral MCCCXXXVII' => build_test('1337 (roman numeral conversion)', 'MCCCXXXVII', '1337'),
    'roman 1337' => build_test('MCCCXXXVII (roman numeral conversion)', '1337', 'MCCCXXXVII'),
    'roman IV' => build_test('4 (roman numeral conversion)', 'IV', '4'),
    '10 in roman numeral' => build_test('X (roman numeral conversion)', '10', 'X'),
    '11 in roman numerals' => build_test('XI (roman numeral conversion)', '11', 'XI'),
    'xiii to arabic' => build_test('13 (roman numeral conversion)', 'XIII', '13'),
    '20 to roman numerals' => build_test('XX (roman numeral conversion)', '20', 'XX'),
);

done_testing;
