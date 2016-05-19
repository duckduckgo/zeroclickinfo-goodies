#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "phone_alphabet";
zci is_cached   => 1;

sub build_test {
    my($text, $input, $number) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $number,
            subtitle => "Phone Number: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::PhoneAlphabet )],
    '1-800-LAWYR-UP to digits' => build_test('Phone Number: 1-800-52997-87', '1-800-LAWYR-UP', '1-800-52997-87'),
    '1-800-fun-hack to phone number' => build_test('Phone Number: 1-800-386-4225', '1-800-fun-hack', '1-800-386-4225'),
    '1-800-fun-hack to numbers' => build_test('Phone Number: 1-800-386-4225', '1-800-fun-hack', '1-800-386-4225'),
    '1958funhack to phone' => build_test('Phone Number: 19583864225', '1958funhack', '19583864225'),
    '13TAXI to phone' => build_test('Phone Number: 138294', '13TAXI', '138294'),
    'something fun to hack to phone' => undef,
    '0x0123 to digits' => undef
);

done_testing;
