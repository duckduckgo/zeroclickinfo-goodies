#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

subtest 'NumberStyler' => sub {

    { package RoleTester; use Moo; with 'DDG::GoodieRole::NumberStyler'; 1; }

    new_ok('RoleTester', [], 'Applied to an object');
    isa_ok(RoleTester::number_style_regex(), 'Regexp', 'number_style_regex()');

    my $style_picker = \&RoleTester::number_style_for;

    my @valid_test_cases = (
        [['0,013'] => 'euro'],
        [['4,431',      '4.321'] => 'perl'],
        [['4,431',      '4,32']  => 'euro'],
        [['4534,345.0', '1']     => 'perl'],    # Unenforced commas.
        [['4,431', '4,32', '5,42'] => 'euro'],
        [['4,431', '4.32', '5.42'] => 'perl'],
    );

    foreach my $tc (@valid_test_cases) {
        my @numbers           = @{$tc->[0]};
        my $expected_style_id = $tc->[1];
        is($style_picker->(@numbers)->id, $expected_style_id, '"' . join(' ', @numbers) . '" yields a style of ' . $expected_style_id);
    }

    my @invalid_test_cases = (
        [['5234534.34.54', '1'] => 'has a mal-formed number'],
        [['4,431', '4,32',     '4.32'] => 'is confusingly ambiguous'],
        [['4,431', '4.32.10',  '5.42'] => 'is hard to figure'],
        [['4,431', '4,32,100', '5.42'] => 'has a mal-formed number'],
        [['4,431', '4,32,100', '5,42'] => 'is too crazy to work out'],
    );

    foreach my $tc (@invalid_test_cases) {
        my @numbers = @{$tc->[0]};
        my $why_not = $tc->[1];
        is($style_picker->(@numbers), undef, '"' . join(' ', @numbers) . '" fails because it ' . $why_not);
    }

};

done_testing;
