#!/usr/bin/env perl

use strict;
use warnings;
use Test::Most;

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
    
    # Initialisation tests
    new_ok('RoleTester', [], 'Applied to an object');
    isa_ok(RoleTester::date_regex(), 'Regexp', 'date_regex()');
    
    # Parsing and handling tests
    my %dates_to_match = (
        # Defined formats:
        #ISO8601
        '2014-11-27'                => 1417046400,
        '1994-02-03 14:15:29 -0100' => 760288529,
        '1994-02-03 14:15:29'       => 760284929,
        '1994-02-03T14:15:29'       => 760284929,
        '19940203T141529Z'          => 760284929,
        '19940203'                  => 760233600,
        #HTTP
        'Sat, 09 Aug 2014 18:20:00' => 1407608400,
        # RFC850
        '08-Feb-94 14:15:29 GMT' => 760716929,
        #Undefined/Natural formats:
        '13/12/2011'        => 1323734400,    #DMY
        '01/01/2001'        => 978307200,     #Ambiguous, but valid
        '29 June 2014'      => 1404000000,    #DMY
        '05 Mar 1990'       => 636595200,     #DMY (short)
        'June 01 2012'      => 1338508800,    #MDY
        'May 05 2011'       => 1304553600,    #MDY
        'may 01 2010'       => 1272672000,
        '1st june 1994'     => 770428800,
        '5 th january 1993' => 726192000,
        'JULY 4TH 1976'     => 205286400,
        '07/13/1984'        => 458524800,
        '7/13/1984'         => 458524800,
        '13/07/1984'        => 458524800,
        '13.07.1984'        => 458524800,
        '7.13.1984'         => 458524800,
        'june-01-2012'      => 1338508800,
        'feb/01/2010'       => 1264982400,
        '01-jun-2012'       => 1338508800,
        '01/june/2012'      => 1338508800,
        'JUN-1-2012'        => 1338508800,
        '4-jUL-1976'        => 205286400,
        '2001-1-1'          => 978307200,
    );

    my $test_regex = RoleTester::date_regex();

    foreach my $test_date (keys %dates_to_match) {
        like($test_date, qr/^$test_regex$/, "$test_date matches");

        my $date_object = RoleTester::parse_string_to_date($test_date);
        isa_ok($date_object, 'DateTime', $test_date);
        is($date_object->epoch, $dates_to_match{$test_date}, '... which represents the correct time.');
    }
    
    # Tests for mangled formats that shouldn't match
    my @strings_to_ignore = (
        '24/8',
        '123',
        '123-84-1',
        '1st january',
        '1/1/1'
    );
    
    foreach my $test_string (@strings_to_ignore) {
        unlike($test_string, qr/^$test_regex$/, "$test_string doesn't match");
        my $result;
        lives_ok { $result = RoleTester::parse_string_to_date($test_string) } '... nor does it kill the parser.';
        is($result, undef, '... and returns undef to signal failure.');
    }

};

done_testing;
