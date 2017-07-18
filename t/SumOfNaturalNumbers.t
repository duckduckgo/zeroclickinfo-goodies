use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'sum';
zci is_cached => 1;

sub build_sum_answer {
    my($title, $subtitle) = @_;
    return $subtitle,
        structured_answer => {
            data => {
                title => "$title",
                subtitle => $subtitle
            },
            templates => {
                group => 'text',
            }
        };
}

sub build_sum_test { test_zci(build_sum_answer(@_)) }

ddg_goodie_test(
    [
        'DDG::Goodie::SumOfNaturalNumbers'
    ],
    'sum 1 to 10' => build_sum_test('55', 'Sum of natural numbers from 1 to 10'),
    'sum 55 to 63' => build_sum_test('531', 'Sum of natural numbers from 55 to 63'),
    'add 33 to 100' => build_sum_test('4,522', 'Sum of natural numbers from 33 to 100'),
    'sum 1-10' => build_sum_test('55', 'Sum of natural numbers from 1 to 10'),
    'sum from 1 to 10' => build_sum_test('55', 'Sum of natural numbers from 1 to 10'),
    '1-10 sum' => build_sum_test('55', 'Sum of natural numbers from 1 to 10'),
    'add from 1 to 100' => build_sum_test('5,050', 'Sum of natural numbers from 1 to 100'),

    # Invalid Input
    'sum 1 --- 10' => undef,
    'sum 100 - 10' => undef,
    'add ten to twenty' => undef,
);

done_testing;
