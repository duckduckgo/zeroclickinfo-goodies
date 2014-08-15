#!/usr/bin/env perl

use strict;
use warnings;

use Test::MockTime qw( :all );
use Test::Most;

use DateTime;

subtest 'NumberStyler' => sub {

    { package RoleTester; use Moo; with 'DDG::GoodieRole::NumberStyler'; 1; }

    subtest 'Initialization' => sub {
        new_ok('RoleTester', [], 'Applied to a class');
        isa_ok(RoleTester::number_style_regex(), 'Regexp', 'number_style_regex()');
    };

    subtest 'Valid numbers' => sub {

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
            is(RoleTester::number_style_for(@numbers)->id,
                $expected_style_id, '"' . join(' ', @numbers) . '" yields a style of ' . $expected_style_id);
        }
    };

    subtest 'Invalid numbers' => sub {
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
            is(RoleTester::number_style_for(@numbers), undef, '"' . join(' ', @numbers) . '" fails because it ' . $why_not);
        }
    };

};

subtest 'Dates' => sub {

    { package RoleTester; use Moo; with 'DDG::GoodieRole::Dates'; 1; }

    my $test_regex;

    subtest 'Initialization' => sub {
        new_ok('RoleTester', [], 'Applied to a class');
        $test_regex = RoleTester::date_regex();
        isa_ok($test_regex, 'Regexp', 'date_regex()');
    };

    subtest 'Working single dates' => sub {
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
            '13/12/2011'        => 1323734400,     #DMY
            '01/01/2001'        => 978307200,      #Ambiguous, but valid
            '29 June 2014'      => 1404000000,     #DMY
            '05 Mar 1990'       => 636595200,      #DMY (short)
            'June 01 2012'      => 1338508800,     #MDY
            'May 05 2011'       => 1304553600,     #MDY
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
            'jan 6, 2014'       => 1388966400,
            '6, jan 2014'       => 1388966400,
            '6 jan, 2014'       => 1388966400,
            '29 feb, 2012'      => 1330473600,
            '2038-01-20'        => 2147558400,     # 32-bit signed int UNIX epoch ends 2038-01-19
            '1780-01-20'        => -5994172800,    # Way before 32-bit signed int epoch
        );

        foreach my $test_date (sort keys %dates_to_match) {
            like($test_date, qr/^$test_regex$/, "$test_date matches the date_regex");

            # test_regex should not contain any submatches
            $test_date =~ qr/^$test_regex$/;
            ok(scalar @- == 1 && scalar @+ == 1, ' with no sub-captures.');

            my $date_object = RoleTester::parse_string_to_date($test_date);
            isa_ok($date_object, 'DateTime', $test_date);
            is($date_object->epoch, $dates_to_match{$test_date}, '... which represents the correct time.');
        }
    };

    subtest 'Working multi-dates' => sub {
        my @date_sets = ({
                src    => ['01/10/2014', '01/06/2014'],
                output => [1389312000,   1388966400],     # 10 jan; 6 jan
            },
            {
                src    => ['01/13/2014', '01/06/2014'],
                output => [1389571200,   1388966400],     # 13 jan; 6 jan
            },
            {
                src    => ['05/06/2014', '20/06/2014'],
                output => [1401926400,   1403222400],     # 5 jun; 20 jun
            },
            {
                src    => ['20/06/2014', '05/06/2014'],
                output => [1403222400,   1401926400],     # 20 jun; 5 jun
            },
            {
                src    => ['5/06/2014', '20/06/2014'],
                output => [1401926400,  1403222400],      # 5 jun; 20 jun
            },
            {
                src    => ['20/06/2014', '5/06/2014'],
                output => [1403222400,   1401926400],     # 20 jun; 5 jun
            },
            {
                src    => ['20-06-2014', '5-06-2014'],
                output => [1403222400,   1401926400],     # 20 jun; 5 jun
            },
            {
                src    => ['5-06-2014', '20-06-2014'],
                output => [1401926400,  1403222400],      # 5 jun; 20 jun
            },
            {
                src    => ['5-June-2014', '20-06-2014'],
                output => [1401926400,    1403222400],     # 5 jun; 20 jun
            },
            {
                src    => ['5-06-2014', '4th January 2013', '20-06-2014'],
                output => [1401926400,  1357257600,         1403222400],     # 5 jun; 4 jan, 20 jun
            },
        );

        foreach my $set (@date_sets) {
            my @source = @{$set->{src}};
            eq_or_diff([map { $_->epoch } (RoleTester::parse_all_strings_to_date(@source))],
                $set->{output}, '"' . join(', ', @source) . '": dates parsed correctly');
        }
    };

    subtest 'Invalid single dates' => sub {
        my %bad_strings_match = (
            '24/8'          => 0,
            '123'           => 0,
            '123-84-1'      => 0,
            '1st january'   => 0,
            '1/1/1'         => 0,
            '2014-13-13'    => 1,
            'Feb 38th 2015' => 1,
            '2014-02-29'    => 1,
        );

        foreach my $test_string (sort keys %bad_strings_match) {
            if ($bad_strings_match{$test_string}) {
                like($test_string, qr/^$test_regex$/, "$test_string matches date_regex");
            } else {
                unlike($test_string, qr/^$test_regex$/, "$test_string does not match date_regex");
            }

            my $result;
            lives_ok { $result = RoleTester::parse_string_to_date($test_string) } '... and does not kill the parser.';
            is($result, undef, '... and returns undef to signal failure.');
        }
    };

    subtest 'Invalid multi-format' => sub {
        my @invalid_date_sets = (
            ['01/13/2014', '13/06/2014'],
            ['13/01/2014', '01/31/2014'],
            ['38/06/2014', '13/06/2014'],
            ['01/13/2014', '01/85/2014'],
            ['13/01/2014', '01/31/2014', '13/06/2014'],
            ['13/01/2014', '2001-01-01', '14/01/2014', '01/31/2014'],
        );

        foreach my $set (@invalid_date_sets) {
            my @source       = @$set;
            my @date_results = RoleTester::parse_all_strings_to_date(@source);
            is(@date_results, 0, '"' . join(', ', @source) . '": cannot be parsed in combination.');
        }
    };

    subtest 'Valid standard string format' => sub {
        my %date_strings = (
            '01 Jan 2001' => ['2001-1-1',   'January 1st, 2001', '1st January, 2001'],
            '13 Jan 2014' => ['13/01/2014', '01/13/2014',        '13th Jan 2014'],
        );

        foreach my $result (sort keys %date_strings) {
            foreach my $test_string (@{$date_strings{$result}}) {
                is(RoleTester::date_output_string($test_string), $result, $test_string . ' normalizes for output as ' . $result);
            }
        }
    };
    subtest 'Invalid standard string format' => sub {
        my %bad_stuff = (
            'Empty string' => '',
            'Hashref'      => {},
            'Object'       => RoleTester->new,
        );
        foreach my $description (sort keys %bad_stuff) {
            my $result;
            lives_ok { $result = RoleTester::date_output_string($bad_stuff{$description}) } $description . ' does not kill the string output';
            is($result, '', '... and yields an empty string as a result');
        }
    };
    subtest 'Vague strings' => sub {
        my %time_strings = (
            '2000-08-01T00:00:00Z' => {
                'next december' => '01 Dec 2000',
                'last january'  => '01 Jan 2000',
                'june'          => '01 Jun 2001',
                'december 2015' => '01 Dec 2015',
                'june 2000'     => '01 Jun 2000',
                'jan'           => '01 Jan 2001',
                'next jan'      => '01 Jan 2001',
                'last jan'      => '01 Jan 2000',
                'feb 2038'      => '01 Feb 2038',
            },
            '2015-12-01T00:00:00Z' => {
                'next december' => '01 Dec 2016',
                'last january'  => '01 Jan 2015',
                'june'          => '01 Jun 2016',
                'december 2015' => '01 Dec 2015',
                'june 2000'     => '01 Jun 2000',
                'jan'           => '01 Jan 2016',
                'next jan'      => '01 Jan 2016',
                'last jan'      => '01 Jan 2015',
                'feb 2038'      => '01 Feb 2038',
            },
        );
        foreach my $query_time (sort keys %time_strings) {
            set_fixed_time($query_time);
            my %strings = %{$time_strings{$query_time}};
            foreach my $test_date (sort keys %strings) {
                my $result = RoleTester::parse_vague_string_to_date($test_date);
                isa_ok($result, 'DateTime', $test_date);
                is(RoleTester::date_output_string($result), $strings{$test_date}, $test_date . ' relative to ' . $query_time);
            }
        }
        restore_time();
    };
};

done_testing;
