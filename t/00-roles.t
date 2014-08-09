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

subtest 'Dates' => sub {

    { package RoleTester; use Moo; with 'DDG::GoodieRole::Dates'; 1; }
use Data::Dump qw(dump);
    new_ok('RoleTester', [], 'Applied to an object');
    isa_ok(RoleTester::date_regex(), 'Regexp', 'date_regex()');

    my @dates_to_match = (
        #Defined formats:
        '2014-11-27',                   #ISO8601
        'Sat, 09 Aug 2014 18:20:00',    #HTTP
        '08-Feb-94 14:15:29 GMT',       # RFC850
        
        #Undefined/Natural formats:
        '13/12/2011',       #DMY
        '01/01/2001',       #Ambiguous, I guess default to MDY?
        '29 June 2014',     #DMY
        '05 Mar 1990',      #DMY (short)
        'June 01 2012',     #MDY
        'May 05 2011',      #MDY
        'may 01 2010',
        '1st june 1994',
    );

    my $test_regex = RoleTester::date_regex();
    #print ok(0, dump($test_regex) . "\n");
    
    foreach my $test_date (@dates_to_match) {
        like( $test_date, $test_regex, "$test_date matches");
        
#        if( $test_date !~ $test_regex ) {
#            ok(0,"$test_date failed!");
#        }
    }
};

done_testing;
