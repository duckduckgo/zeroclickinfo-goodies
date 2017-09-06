#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'roman_numeral_conversion';
zci is_cached   => 1;

sub build_test {
    my ($input, $input_value, $output, $output_value) = @_;
    return test_zci('roman numeral converter', structured_answer => {
        data => {
            subtitle => 'Accepts inputs from 1 - 3999, I - MMMCMXCIX',
            input => $input,
            input_value => $input_value,
            output => $output,
            output_value => $output_value
        },
        templates => {
            group => 'text',
            options => {
                title_content => 'DDH.roman.content',
            }
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Roman )],
    'roman 15' => build_test('arabic', '15', 'roman', 'XV'),
    "roman xii" => build_test('roman', 'XII', 'arabic', '12'),
    "roman mmcml" => build_test('roman', 'MMCML', 'arabic', '2950'),
    "roman 2344" => build_test('arabic', '2344', 'roman', 'MMCCCXLIV'),
    "arabic cccxlvi" => build_test('roman', 'CCCXLVI', 'arabic', '346'),
    'roman MCCCXXXVII' => build_test('roman', 'MCCCXXXVII', 'arabic','1337'),
    'roman numeral 10' => build_test('arabic', '10', 'roman', 'X'),
    'roman numeral XVI' => build_test('roman', 'XVI', 'arabic', '16'),
    'roman 1337' => build_test('arabic', '1337', 'roman','MCCCXXXVII'),
    'roman IV' => build_test('roman', 'IV', 'arabic', '4'),
    '1492 in roman numerals' => build_test('arabic', '1492', 'roman', 'MCDXCII'),
    '10 into roman' => build_test('arabic', '10', 'roman', 'X'),
    '3999 in roman numeral' => build_test('arabic', '3999', 'roman', 'MMMCMXCIX'),
    'xiii to arabic' => build_test('roman', 'XIII', 'arabic', '13'),
    'CXIII to arabic' => build_test('roman', 'CXIII', 'arabic', '113'),
    'convert XXX into arabic' => build_test('roman', 'XXX', 'arabic', '30'),
    'convert MMCC to arabic' => build_test('roman', 'MMCC', 'arabic', '2200'),
    'convert 15 to roman' => build_test('arabic', '15', 'roman', 'XV'),
    'convert 30 into roman' => build_test('arabic', '30', 'roman', 'XXX'),
    'convert to arabic' => build_test('roman', '', 'arabic', ''),
    'foo to arabic numerals' => undef,
    'roman man' => undef
);

done_testing;
