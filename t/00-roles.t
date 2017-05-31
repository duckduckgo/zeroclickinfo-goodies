#!/usr/bin/env perl

use strict;
use warnings;

use Test::MockTime qw( :all );
use Test::Most;

use DDG::Test::Location;

subtest 'NumberStyler' => sub {

    { package NumberRoleTester; use Moo; with 'DDG::GoodieRole::NumberStyler'; 1; }

    subtest 'Initialization' => sub {
        new_ok('NumberRoleTester', [], 'Applied to a class');
        isa_ok(NumberRoleTester::number_style_regex(), 'Regexp', 'number_style_regex()');
    };

    subtest 'Valid numbers' => sub {

        my @valid_test_cases = (
            [['0,013'] => 'euro'],
            [['4,431',      '4.321'] => 'perl'],
            [['4,431',      '4,32']  => 'euro'],
            [['4534,345.0', '1']     => 'perl'],    # Unenforced commas.
            [['4,431',     '4,32', '5,42']       => 'euro'],
            [['4,431',     '4.32', '5.42']       => 'perl'],
            [['4_431_123', '4 32', '99.999 999'] => 'perl'],
            [['4e1', '-1e25', '4.5e-25'] => 'perl'],
            [['-1,1e25', '4,5e-25'] => 'euro'],
            [['4E1', '-1E25', '4.5E-25'] => 'perl'],
            [['-1,1E25', '4,5E-25'] => 'euro'],
        );

        my $number_style_regex = NumberRoleTester::number_style_regex();
        foreach my $tc (@valid_test_cases) {
            my @numbers           = @{$tc->[0]};
            my $expected_style_id = $tc->[1];
            is(NumberRoleTester::number_style_for(@numbers)->id,
                $expected_style_id, '"' . join(' ', @numbers) . '" yields a style of ' . $expected_style_id);
            like($_, qr/^$number_style_regex$/, "$_ matches the number_style_regex") for(@numbers);
        }
    };

    subtest 'Invalid numbers' => sub {
        my @invalid_test_cases = (
            [['5234534.34.54', '1'] => 'has a mal-formed number'],
            [['4,431',     '4,32',     '4.32']       => 'is confusingly ambiguous'],
            [['4,431',     '4.32.10',  '5.42']       => 'is hard to figure'],
            [['4,431',     '4,32,100', '5.42']       => 'has a mal-formed number'],
            [['4,431',     '4,32,100', '5,42']       => 'is too crazy to work out'],
            [['4_431_123', "4\t32",    '99.999 999'] => 'no tabs in numbers'],
        );

        foreach my $tc (@invalid_test_cases) {
            my @numbers = @{$tc->[0]};
            my $why_not = $tc->[1];
            is(NumberRoleTester::number_style_for(@numbers), undef, '"' . join(' ', @numbers) . '" fails because it ' . $why_not);
        }
    };

};

subtest 'Dates' => sub {

    { package DatesRoleTester; use Moo; with 'DDG::GoodieRole::Dates'; 1; }

    my $test_datestring_regex;
    my $test_formatted_datestring_regex;
    my $test_descriptive_datestring_regex;

    subtest 'Initialization' => sub {
        new_ok('DatesRoleTester', [], 'Applied to a class');
        $test_datestring_regex = DatesRoleTester::datestring_regex();
        isa_ok($test_datestring_regex, 'Regexp', 'datestring_regex()');
        $test_formatted_datestring_regex = DatesRoleTester::formatted_datestring_regex();
        isa_ok($test_formatted_datestring_regex, 'Regexp', 'formatted_datestring_regex()');
        $test_descriptive_datestring_regex = DatesRoleTester::descriptive_datestring_regex();
        isa_ok($test_descriptive_datestring_regex, 'Regexp', 'descriptive_datestring_regex()');
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
            # date(1) default
            'Sun Sep  7 15:57:56 EST 2014' => 1410123476,
            'Sun Sep  7 15:57:56 EDT 2014' => 1410119876,
            'Sun Sep 14 15:57:56 UTC 2014' => 1410710276,
            'Sun Sep 7 20:11:44 CET 2014'  => 1410117104,
            'Sun Sep 7 20:11:44 BST 2014'  => 1410117104,
            # RFC 2822
            'Sat, 13 Mar 2010 11:29:05 -0800' => 1268508545,
            # HTTP (without day) - any TZ
            # %d %b %Y %H:%M:%S %Z
            '01 Jan 2012 00:01:20 UTC' => 1325376080,
            '22 Jun 1998 00:00:02 GMT' => 898473602,
            '07 Sep 2014 20:11:44 CET' => 1410117104,
            '07 Sep 2014 20:11:44 cet' => 1410117104,
            '09 Aug 2014 18:20:00'     => 1407608400,
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
            '5th of january 1993' => 726192000,
            '5 of jan 1993'     => 726192000,
            'june the 1st 2012' => 1338508800,
            "11 march 2000 00:00:00" => 952732800
        );

        foreach my $test_date (sort keys %dates_to_match) {
            like($test_date, qr/^$test_datestring_regex$/, "$test_date matches the datestring_regex");
            like($test_date, qr/^$test_formatted_datestring_regex$/, "$test_date matches the formatted_datestring_regex");

            # test_regex should not contain any submatches
            $test_date =~ qr/^$test_datestring_regex$/;
            ok(scalar @- == 1 && scalar @+ == 1, ' with no sub-captures.');

            $test_formatted_datestring_regex =~ qr/^$test_datestring_regex$/;
            ok(scalar @- == 1 && scalar @+ == 1, ' with no sub-captures.');

            my $date_object = DatesRoleTester::parse_formatted_datestring_to_date($test_date);
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
            {
                src    => ['7-11-2015', 'august'],
                output => [1436572800,  1438387200],     # 11 jul; aug 1
            },
        );

        foreach my $set (@date_sets) {
            my @source = @{$set->{src}};
            eq_or_diff([map { $_->epoch } (DatesRoleTester::parse_all_datestrings_to_date(@source))],
                $set->{output}, '"' . join(', ', @source) . '": dates parsed correctly');
        }
    };

    subtest 'Strong dates and vague or relative dates mixed' => sub {
        set_fixed_time('2001-02-05T00:00:00Z');
        my @date_sets = (
            {
                src => ["1990-06-13", "december"],
                out => ['1990-06-13T00:00:00', '1990-12-01T00:00:00']
            },
#            {
#                src => ["1990-06-13", "last december"],
#                out => ['1990-06-13T00:00:00', '2000-12-01T00:00:00']
#            },
#            {
#                src => ["1990-06-13", "next december"],
#                out => ['1990-06-13T00:00:00', '2001-12-01T00:00:00']
#            },
            {
                src => ["1990-06-13", "today"],
                out => ['1990-06-13T00:00:00', '2001-02-05T00:00:00']
            },
            {
                src => ["1990-06-13", "tomorrow"],
                out => ['1990-06-13T00:00:00', '2001-02-06T00:00:00']
            },
            {
                src => ["1990-06-13", "yesterday"],
                out => ['1990-06-13T00:00:00', '2001-02-04T00:00:00']
            }
        );

        foreach my $set (@date_sets) {
            my @source = @{$set->{src}};
            my @expectation = @{$set->{out}};
            my @result = DatesRoleTester::parse_all_datestrings_to_date(@source);
            is_deeply(\@result, \@expectation, join(", ", @source));
        }

        restore_time();
    };

    subtest 'Relative naked months' => sub {

        my %time_strings = (
            "2015-01-13T00:00:00Z" => {
                src    => ['january', 'february'],
                output => ['2015-01-01T00:00:00', '2015-02-01T00:00:00'],
            },
            "2015-02-01T00:00:00Z" => {
                src    => ['january', 'february'],
                output => ['2016-01-01T00:00:00',  '2016-02-01T00:00:00'],
            },
            "2015-03-01T00:00:00Z" => {
                src    => ['january', 'february'],
                output => ['2016-01-01T00:00:00',  '2016-02-01T00:00:00'],
            },
            "2014-12-01T00:00:00Z" => {
                src    => ['january', 'february'],
                output => ['2015-01-01T00:00:00',  '2015-02-01T00:00:00'],
            },

        );

        foreach my $query_time (sort keys %time_strings) {
            set_fixed_time($query_time);

            my @source = @{$time_strings{$query_time}{src}};
            my @expectation = @{$time_strings{$query_time}{output}};
            my @result = DatesRoleTester::parse_all_datestrings_to_date(@source);

            is_deeply(\@result, \@expectation);
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
                like($test_string, qr/^$test_formatted_datestring_regex$/, "$test_string matches formatted_datestring_regex");
            } else {
                unlike($test_string, qr/^$test_formatted_datestring_regex$/, "$test_string does not match formatted_datestring_regex");
            }

            my $result;
            lives_ok { $result = DatesRoleTester::parse_formatted_datestring_to_date($test_string) } '... and does not kill the parser.';
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
            my @date_results = DatesRoleTester::parse_all_datestrings_to_date(@source);
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
                is(DatesRoleTester::date_output_string($test_string), $result, $test_string . ' normalizes for output as ' . $result);
            }
        }
    };
    subtest 'Valid clock string format' => sub {
        my %date_strings = (
            '01 Jan 2012 00:01:20 UTC'   => ['01 Jan 2012 00:01:20 UTC', '01 Jan 2012 00:01:20 utc'],
            '22 Jun 1998 00:00:02 UTC'   => ['22 Jun 1998 00:00:02 GMT'],
            '07 Sep 2014 20:11:44 EST'   => ['07 Sep 2014 20:11:44 EST'],
            '07 Sep 2014 20:11:44 -0400' => ['07 Sep 2014 20:11:44 EDT'],
            '09 Aug 2014 18:20:00 UTC'   => ['09 Aug 2014 18:20:00'],
        );
        foreach my $result (sort keys %date_strings) {
            foreach my $test_string (@{$date_strings{$result}}) {
                is(DatesRoleTester::date_output_string($test_string, 1), $result, $test_string . ' normalizes for output as ' . $result);
            }
        }
    };
    subtest 'Invalid standard string format' => sub {
        my %bad_stuff = (
            'Empty string' => '',
            'Hashref'      => {},
            'Object'       => DatesRoleTester->new,
        );
        foreach my $description (sort keys %bad_stuff) {
            my $result;
            lives_ok { $result = DatesRoleTester::date_output_string($bad_stuff{$description}) } $description . ' does not kill the string output';
            is($result, '', '... and yields an empty string as a result');
        }
    };
    subtest 'Vague strings' => sub {
        my %time_strings = (
            '2000-08-01T00:00:00Z' => {
                'next december' => '01 Dec 2000',
                'last january'  => '01 Jan 2000',
                'this year'     => '01 Aug 2000',
                'june'          => '01 Jun 2001',
                'december 2015' => '01 Dec 2015',
                'june 2000'     => '01 Jun 2000',
                'jan'           => '01 Jan 2001',
                'august'        => '01 Aug 2000',
                'aug'           => '01 Aug 2000',
                'next jan'      => '01 Jan 2001',
                'last jan'      => '01 Jan 2000',
                'feb 2038'      => '01 Feb 2038',
                'next day'      => '02 Aug 2000',
            },
            '2015-12-01T00:00:00Z' => {
                'next december' => '01 Dec 2016',
                'last january'  => '01 Jan 2015',
                'june'          => '01 Jun 2016',
                'december'      => '01 Dec 2015',
                'december 2015' => '01 Dec 2015',
                'june 2000'     => '01 Jun 2000',
                'jan'           => '01 Jan 2016',
                'next jan'      => '01 Jan 2016',
                'last jan'      => '01 Jan 2015',
                'feb 2038'      => '01 Feb 2038',
                'now'           => '01 Dec 2015',
                'today'         => '01 Dec 2015',
                'current day'   => '01 Dec 2015',
                'next month'    => '01 Jan 2016',
                'this week'     => '01 Dec 2015',
                '1 month ago'   => '01 Nov 2015',
                '2 years ago'   => '01 Dec 2013'
            },
            '2000-01-01T00:00:00Z' => {
                'feb 21st'          => '21 Feb 2000',
                'january'           => '01 Jan 2000',
                '11th feb'          => '11 Feb 2000',
                'march 13'          => '13 Mar 2000',
                '12 march'          => '12 Mar 2000',
                'next week'         => '08 Jan 2000',
                'last week'         => '25 Dec 1999',
                'tomorrow'          => '02 Jan 2000',
                'yesterday'         => '31 Dec 1999',
                'last year'         => '01 Jan 1999',
                'next year'         => '01 Jan 2001',
                'in a day'          => '02 Jan 2000',
                'in a week'         => '08 Jan 2000',
                'in a month'        => '01 Feb 2000',
                'in a year'         => '01 Jan 2001',
                'in 1 day'          => '02 Jan 2000',
                'in 2 weeks'        => '15 Jan 2000',
                'in 3 months'       => '01 Apr 2000',
            },
            '2014-10-08T00:00:00Z' => {
                'next week'         => '15 Oct 2014',
                'this week'         => '08 Oct 2014',
                'last week'         => '01 Oct 2014',
                'next month'        => '08 Nov 2014',
                'this month'        => '08 Oct 2014',
                'last month'        => '08 Sep 2014',
                'next year'         => '08 Oct 2015',
                'this year'         => '08 Oct 2014',
                'last year'         => '08 Oct 2013',
                'december 2015'     => '01 Dec 2015',
                'march 13'          => '13 Mar 2014',
                'in a weeks time'   => '15 Oct 2014',
                '2 months ago'      => '08 Aug 2014',
                'in 2 years'        => '08 Oct 2016',
                'a week ago'        => '01 Oct 2014',
                'a month ago'       => '08 Sep 2014',
                'in 2 days'         => '10 Oct 2014'
            },
        );
        foreach my $query_time (sort keys %time_strings) {
            set_fixed_time($query_time);
            my %strings = %{$time_strings{$query_time}};
            foreach my $test_date (sort keys %strings) {
                like($test_date, qr/^$test_descriptive_datestring_regex$/, "$test_date matches the descriptive_datestring_regex");
                my $result = DatesRoleTester::parse_descriptive_datestring_to_date($test_date);
                isa_ok($result, 'DateTime', $test_date);
                is(DatesRoleTester::date_output_string($result), $strings{$test_date}, $test_date . ' relative to ' . $query_time);
            }
        }
        restore_time();
    };

    subtest 'Valid mixture of formatted and descriptive dates' => sub {
        set_fixed_time('2000-01-01T00:00:00Z');
        my %mixed_dates_to_test = (
            '2014-11-27'                => 1417046400,
            '1994-02-03T14:15:29'       => 760284929,
            'Sat, 09 Aug 2014 18:20:00' => 1407608400,
            '08-Feb-94 14:15:29 GMT'    => 760716929,
            '13/12/2011'                => 1323734400,
            '01/01/2001'                => 978307200,
            '29 June 2014'              => 1404000000,
            '05 Mar 1990'               => 636595200,
            'June 01 2012'              => 1338508800,
            'May 05 2011'               => 1304553600,
            'February 21st'             => 951091200,
            '11th feb'                  => 950227200,
            '11 march'                  => 952732800,
            '11 mar'                    => 952732800,
            'jun 21'                    => 961545600,
            'next january'              => 978307200,
            'december'                  => 975628800,
            '22 may 2000 08:00:00'      => 958982400,
            '22 may 08:00:00'           => 958982400,
            '22 may 08:00'              => 958982400,
            '08:00 22 may'              => 958982400,
        );

        foreach my $test_mixed_date (sort keys %mixed_dates_to_test) {
            like($test_mixed_date, qr/^$test_datestring_regex$/, "$test_mixed_date matches the datestring_regex");
            my $parsed_date_object = DatesRoleTester::parse_datestring_to_date($test_mixed_date);
            isa_ok($parsed_date_object, 'DateTime', $test_mixed_date);
            is($parsed_date_object->epoch, $mixed_dates_to_test{$test_mixed_date}, ' ... represents the correct time.');
        }

        restore_time();
    };

    subtest 'Relative dates with location' => sub {
        my $test_location = test_location('in');
        {
            package DDG::Goodie::FakerDater;
            use Moo;
            with 'DDG::GoodieRole::Dates';
            our $loc = $test_location;
            sub pds { shift; parse_datestring_to_date(@_); }
            1;
        }

        my $with_loc = new_ok('DDG::Goodie::FakerDater', [], 'With location');
        set_fixed_time('2013-12-31T23:00:00Z');
        my $today_obj;
        lives_ok { $today_obj = $with_loc->pds('today'); } 'Parsed out today at just before midnight UTC NYE, 2013';
        is($today_obj->time_zone_long_name, 'Asia/Kolkata', '... in our local time zone');
        is($today_obj->year,                2014,           '... where it is already 2014');
        is($today_obj->hms,                 '04:30:00',     '... for about 4.5 hours');
        is($today_obj->offset / 3600,       5.5,            '... which seems just about right.');

        restore_time();
    };
    subtest 'Valid Years' => sub {
        #my @valids = ('1', '0001', '9999', 2015, 1997);
        my @valids = ('1');
        my @invalids = (-1, 0, 10000);

        foreach my $case (@valids) {
            my $result;
            lives_ok {
                $result = DatesRoleTester::is_valid_year($case)
            };
            is($result, "1", "$case is a valid year");
        }

        foreach my $case (@invalids) {
            my $result;
            lives_ok {
                $result = DatesRoleTester::is_valid_year($case)
            };
            is($result, '', "$case is an invalid year");
        }
    }
};

subtest 'ImageLoader' => sub {

    subtest 'object with no share' => sub {
        # We have to wrap the function in a method in order to get the call-stack correct.
        { package ImgRoleTester; use Moo; with 'DDG::GoodieRole::ImageLoader'; sub img_wrap { shift; goodie_img_tag(@_); } 1; }

        my $no_share;
        subtest 'Initialization' => sub {
            $no_share = new_ok('ImgRoleTester', [], 'Applied to class');
        };

        subtest 'non-share enabled object attempts' => sub {
            my %no_deaths = (
                'undef'             => undef,
                'array ref'         => [],
                'killer code ref'   => sub { die },
                'with itself'       => $no_share,
                'empty hash ref'    => +{},
                'nonsense hash ref' => {ding => 'dong'},
                'proper'            => {filename => 'hi.jpg'},
            );
            foreach my $desc (sort keys %no_deaths) {
                lives_ok { $no_share->goodie_img_tag($no_deaths{$desc}) } $desc . ': does not die.';
            }
        };
    };
    subtest 'object with a share' => sub {
        our $b64_gif =
          'R0lGODlhEAAOALMAAOazToeHh0tLS/7LZv/0jvb29t/f3//Ub//ge8WSLf/rhf/3kdbW1mxsbP//mf///yH5BAAAAAAALAAAAAAQAA4AAARe8L1Ekyky67QZ1hLnjM5UUde0ECwLJoExKcppV0aCcGCmTIHEIUEqjgaORCMxIC6e0CcguWw6aFjsVMkkIr7g77ZKPJjPZqIyd7sJAgVGoEGv2xsBxqNgYPj/gAwXEQA7';
        our $final_src = 'src="data:image/gif;base64,' . $b64_gif;
        {

            package DDG::Goodie::ImgShareTester;
            use Moo;
            use HTML::Entities;
            use Path::Class;    # Hopefully the real share stays implemented this way.
            use MIME::Base64;
            with 'DDG::GoodieRole::ImageLoader';
            our $tmp_dir = Path::Class::tempdir(CLEANUP => 1);
            our $tmp_file = file(($tmp_dir->tempfile(TEMPLATE => 'img_XXXXXX', SUFFIX => '.gif'))[1]);
            # Always return the same file for our purposes here.
            sub share     { $tmp_file }
            sub html_enc  { encode_entities(@_) }                                             # Deal with silly symbol table twiddling.
            sub fill_temp { $tmp_file->spew(iomode => '>:bytes', decode_base64($b64_gif)) }
            sub kill_temp { undef $tmp_file }
            sub img_wrap { shift; goodie_img_tag(@_); }
            1;
        }

        my $with_share;
        subtest 'Initialization' => sub {
            $with_share = new_ok('DDG::Goodie::ImgShareTester', [], 'Applied to class');
        };

        subtest 'tag creation' => sub {
            my $filename = $with_share->share()->stringify;
            my $tag_content;
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename}) } 'Empty file does not die';
            is($tag_content, '', '... but returns empty tag.');
            $with_share->fill_temp;
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename}) } 'Newly filled file does not die';
            like($tag_content, qr/$final_src/, '... contains proper data');
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, alt => 'Yo!'}) } 'With alt';
            like($tag_content, qr/$final_src/,  '... contains proper data');
            like($tag_content, qr/alt=\"Yo!\"/, '... and proper alt attribute');
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, alt => 'Yo!', height => 12}) } 'Plus height';
            like($tag_content, qr/$final_src/,  '... contains proper data');
            like($tag_content, qr/alt="Yo!"/,   '... and proper alt attribute');
            like($tag_content, qr/height="12"/, '... and proper height attribute');
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, alt => 'Yo!', height => 12, width => 10}) } 'Plus width';
            like($tag_content, qr/$final_src/,  '... contains proper data');
            like($tag_content, qr/alt="Yo!"/,   '... and proper alt attribute');
            like($tag_content, qr/height="12"/, '... and proper height attribute');
            like($tag_content, qr/width="10"/,  '... and proper width attribute');
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, alt => 'hello"there!', height => 12, width => 10, class => 'smooth' }); } 'Plus class';
            like($tag_content, qr/$final_src/,              '... contains proper data');
            like($tag_content, qr/alt="hello&quot;there!"/, '... and proper alt attribute');
            like($tag_content, qr/height="12"/,             '... and proper height attribute');
            like($tag_content, qr/width="10"/,              '... and proper width attribute');
            like($tag_content, qr/class="smooth"/,          '... and proper class attribute');
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, atl => 'Yo!', height => 12, width => 10, class => 'smooth'}) }
            'Any mispelled does not die';
            is($tag_content, '', '... but yields an empty tag');
            $with_share->kill_temp;
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, alt => 'Yo!', height => 12, width => 10, class => 'smooth'}) }
            'File disappeared does not die';
            is($tag_content, '', '... but yields an empty tag');
        };
    };
};

my %wi_valid_queries = ();
subtest 'WhatIs' => sub {

    { package WhatIsTester; use Moo; with 'DDG::GoodieRole::WhatIs'; 1; }

    subtest 'Initialization' => sub {
        new_ok('WhatIsTester', [], 'Applied to a class');
    };

#######################################################################
#                               Helpers                               #
#######################################################################

    sub build_value_test {
        my ($trans, $expecting_value, %forms) = @_;
        return sub {
            foreach my $key (keys %forms) {
                my $expected = $expecting_value ? $forms{$key} : undef;
                my $result = $trans->full_match($key);
                if (ref $expected eq 'HASH') {
                    cmp_deeply($result, superhashof($expected), "Checking details for: $key");
                } else {
                    is($result->{'primary'}, $expected, "Got an incorrect result for: $key");
                }
            };
        };
    }

    sub wi_with_test {
        my $options = shift;
        my $wi = WhatIsTester::wi(%{$options});
        isa_ok($wi, 'DDG::GoodieRole::WhatIs::Matcher', 'wi');
        return $wi;
    }

    sub add_valid_queries {
        my ($name, %queries) = @_;
        $wi_valid_queries{$name} = \%queries;
    }
    # Usage:
    #
    # add_option_queries 'test name' =>
    #     { opt1 => val1, ..., optn => valn }, (
    #     'query 1' => 'expected response',
    #     'query 2' => 'expected response',
    #     'query 3' => undef, # Should not get a response
    # );
    # # The 'options' are additional values that must match in the result
    # hash.
    sub add_option_queries {
        my ($name, $options, %queries) = @_;
        my %opt_queries = map {
            my $response = $queries{$_};
            if (defined $response) {
                my %opts = (%{$options}, ref $response eq 'HASH'
                    ? %{$response} : (primary => $response));
                $_ => \%opts;
            } else {
                $_ => undef;
            }
        } (keys %queries);
        $wi_valid_queries{$name} = \%opt_queries;
    }
    # Check if a query (or set of queries) should be ignored based on the
    # subtest specification.
    sub should_skip {
        my ($name, $query, $ignore_re) = @_;
        if (ref $ignore_re eq 'Regexp') {
            return $query =~ $ignore_re;
        } elsif (ref $ignore_re eq 'ARRAY') {
            foreach my $ignore (@{$ignore_re}) {
                return 1 if should_skip($name, $query, $ignore);
            }
        } else {
            return $name eq $ignore_re;
        }
        return 0;
    }

    sub modifier_test {
        my $testf = shift;
        my %wi_options = (
            to => 'Goatee',
            from => 'Gribble',
            primary => qr/[10]{4} ?[10]{4}/,
            command => qr/lower ?case|lc/i,
            postfix_command => qr/lowercased/i,
            prefix_command  => qr/lower ?case|lc/i,
            property => 'prime factor',
            singular_property => 'prime factorization',
            plural_property => 'prime divisors',
        );
        return sub {
            my %options = @_;
            my @use_options = @{$options{'use_options'} or []};
            my $use_groups = $options{'use_groups'};
            my @modifiers = @{$options{'modifiers'}};
            my $ignore_re = $options{'ignore'};
            my %spec_options = %{$options{'options'} || {}};
            my %valid_queries;
            foreach my $modifier (@modifiers) {
                %valid_queries = (%valid_queries, %{$wi_valid_queries{$modifier}});
            };
            my %wi_opts;
            @wi_opts{@use_options} = @wi_options{@use_options};
            %wi_opts = (%wi_opts, %spec_options);
            my $wi = $testf->({
                groups => $use_groups,
                options => \%wi_opts,
            });
            subtest 'Valid Queries' => build_value_test($wi, 1, %valid_queries);
            my %invalid_queries = %{$options{'invalid_queries'}} if defined $options{'invalid_queries'};
            foreach my $invalid (keys %wi_valid_queries) {
                next if grep { $_ eq $invalid } @modifiers;
                if (defined $ignore_re) {
                    my %to_add;
                    foreach my $query (keys %{$wi_valid_queries{$invalid}}) {
                        next if should_skip($invalid, $query, $ignore_re);
                        $to_add{$query} = $wi_valid_queries{$invalid}->{$query};
                    };
                    %invalid_queries = (%invalid_queries, %to_add);
                } else {
                    %invalid_queries = (%invalid_queries, %{$wi_valid_queries{$invalid}});
                };
            };
            subtest 'Invalid Queries' => build_value_test($wi, 0, %invalid_queries);
        };
    }
    sub test_custom { modifier_test(\&wi_with_test)->(@_) };

    sub hash_tester {
        my $hashf = shift;
        return sub {
            my %tests = @_;
            return sub {
                while (my ($test_name, $params) = each %tests) {
                    subtest $test_name => sub { $hashf->(%{$params}) };
                };
            };
        };
    }

    sub wi_tests { hash_tester(\&test_custom)->(@_) }

#######################################################################
#                      Test Queries and Results                       #
#######################################################################

    add_option_queries 'spoken translation' =>
        { direction => 'to', verb => 'say' }, (
        "How do I say foo in Goatee?"           => 'foo',
        "How would I say bar in Goatee"         => 'bar',
        "how to say baz in Goatee"              => 'baz',
        "How would you say bribble in Goatee"   => 'bribble',
        "How to say so much testing! in Goatee" => 'so much testing!',
    );
    add_option_queries 'written translation' =>
        { direction => 'to', verb => 'write' }, (
        "How do I write foo in Goatee?"           => 'foo',
        "How would I write bar in Goatee"         => 'bar',
        "how to write baz in Goatee"              => 'baz',
        "How would you write bribble in Goatee"   => 'bribble',
        "How to write so much testing! in Goatee" => 'so much testing!',
    );
    add_valid_queries 'prefix command' => (
        'lowercase FOO'  => {
            command        => 'lowercase',
            prefix_command => 'lowercase',
            primary        => 'FOO',
        },
        'lc bar'         => {
            command        => 'lc',
            prefix_command => 'lc',
            primary        => 'bar',
        },
        'loWer case baz' => {
            command        => 'loWer case',
            prefix_command => 'loWer case',
            primary        => 'baz',
        },
    );
    add_option_queries 'conversion from' =>
        { direction => 'from' }, (
        'hello from Gribble' => 'hello',
        'hello FroM Gribble' => 'hello',
    );
    add_option_queries 'conversion to' =>
        { direction => 'to' }, (
        'hello to Goatee'          => 'hello',
        'convert 5 peas TO Goatee' => '5 peas',
        "What is foo IN Goatee?"    => 'foo',
        "what is bar in Goatee"     => 'bar',
        "What is Goatee in Goatee?" => "Goatee",
        "What is in Goatee"         => "What is",
        "What is in Goatee?"        => undef,
    );
    add_option_queries 'conversion to (numeric)' =>
        { direction => 'to', primary => { numeric => 1 } }, (
        '5 foo to Goatee' => {
            primary => {
                full_match => '5 foo',
                match      => 'foo',
                numeric    => 5,
            }
        },
        'What is 7 Goatee in Goatee?' => {
            primary => {
                full_match => '7 Goatee',
                match      => 'Goatee',
                numeric    => 7,
            },
        },
    );
    add_option_queries 'conversion to (primary)' =>
        { direction => 'to' }, (
        '1011 0101 in Goatee' => '1011 0101',
        '1011 0101 to Goatee' => '1011 0101',
        'what is 1011 0101 in Goatee' => '1011 0101',
    );
    add_option_queries 'conversion to (unit)' =>
        { direction => 'to' }, (
        'hello meters to Goatee' => {
            primary => {
                full_match => 'hello meters',
                match      => 'hello',
                unit       => 'meters',
            },
        },
        'convert 5 m to Goatee'  => {
            primary => {
                full_match => '5 m',
                match      => '5',
                unit       => 'm',
            },
        },
        '5m to Goatee'           => {
            primary => {
                full_match => '5m',
                match      => '5',
                unit       => 'm',
            },
        },
        'what is hello meters in Goatee' => {
            primary => {
                full_match => 'hello meters',
                match      => 'hello',
                unit       => 'meters',
            },
        },
        'what is 5 m in Goatee' => {
            primary => {
                full_match => '5 m',
                match      => '5',
                unit       => 'm',
            },
        },
        'what is 5m in Goatee?' => {
            primary => {
                full_match => '5m',
                match      => '5',
                unit       => 'm',
            },
        },
    );
    add_valid_queries 'command (postfix)' => (
        'FriBble lowercased' => {
            command         => 'lowercased',
            postfix_command => 'lowercased',
            primary         => 'FriBble'
        }
    );
    add_valid_queries 'postfix command (command)' => (
        'FriBble lowercase' => {
            command         => 'lowercase',
            postfix_command => 'lowercase',
            primary         => 'FriBble'
        }
    );
    add_option_queries 'property (plural)' =>
        { is_plural => 1 }, (
        'What are the prime divisors of 122?' => '122',
        'prime divisors of 27'                => '27',
        'what are the prime divisors for 15'  => '15',
        'the prime divisors of 29'            => '29',
        'what are prime divisors of 29'       => undef,
    );
    add_option_queries 'property (property plural)' =>
        { is_plural => 1 }, (
        'What are the prime factors of 122?' => '122',
        'prime factors of 27'                => '27',
        'what are the prime factors for 15'  => '15',
        'the prime factors of 29'            => '29',
        'what are prime factors of 29'       => undef,
    );
    add_option_queries 'property (property singular)' =>
        { is_plural => 0 }, (
        'What is the prime factor of 3'      => '3',
        'prime factor of 7'                  => '7',
        'what is the prime factor for 29'    => '29',
        'the prime factor of 29'             => '29',
        'what is prime factor of 29'         => undef,
    );
    add_option_queries 'property (singular)' =>
        { is_plural => 0 }, (
        'What is the prime factorization of 3'      => '3',
        'prime factorization of 7'                  => '7',
        'what is the prime factorization for 29'    => '29',
        'the prime factorization of 29'             => '29',
        'what is prime factorization of 29'         => undef,
    );
    add_option_queries 'language translation (to)' =>
        { direction => 'to' }, (
        'translate hello to Goatee' => 'hello',
    );
    add_option_queries 'language translation (from)' =>
        { direction => 'from' }, (
        'translate hello from Gribble' => 'hello',
    );

#######################################################################
#                                Tests                                #
#######################################################################

    subtest 'Translations' => wi_tests(
        'Spoken' => {
            use_options => ['to'],
            options     => {
                verb => qr/say/i,
            },
            use_groups  => ['translation', 'verb'],
            modifiers   => ['spoken translation'],
        },
        'Written' => {
            use_options => ['to'],
            options     => {
                verb => qr/write/i,
            },
            use_groups  => ['translation', 'verb'],
            modifiers   => ['written translation'],
        },
        'Written and Spoken' => {
            use_options => ['to'],
            options     => {
                verb => qr/(say|write)/i,
            },
            use_groups  => ['translation', 'verb'],
            modifiers   => ['spoken translation',
                            'written translation'],
        },
        'Language' => {
            use_options => ['to'],
            use_groups  => ['translation', 'language'],
            modifiers   => ['language translation (to)'],
        },
        'Language from' => {
            use_options => ['from'],
            use_groups  => ['translation', 'language'],
            modifiers   => ['language translation (from)'],
        },
        'Language bidirectional' => {
            use_options => ['from', 'to'],
            use_groups  => ['translation', 'language'],
            modifiers   => ['language translation (from)',
                            'language translation (to)'],
        },
        'Language with conversion to' => {
            use_options => ['to'],
            use_groups  => ['translation', 'language', 'conversion'],
            modifiers   => ['language translation (to)',
                            'conversion to'],
            ignore      => qr/ (in|to) /i,
        },
    );

    subtest 'Conversion' => wi_tests(
        'Conversion to (primary)' => {
            use_options => ['to', 'primary'],
            use_groups  => ['conversion'],
            modifiers   => ['conversion to (primary)'],
        },
        'Conversion to' => {
            use_options => ['to'],
            use_groups  => ['conversion'],
            modifiers   => ['conversion to'],
            ignore      => qr/ (to|in) /i,
        },
        'Conversion to (unit)' => {
            use_options => ['to'],
            options => {
                primary => {
                    unit => {
                        symbol => 'm',
                        word   => qr/meters?/i,
                    },
                },
            },
            use_groups  => ['conversion'],
            modifiers   => ['conversion to (unit)'],
        },
        'Conversion to (numeric)' => {
            use_options => ['to'],
            options     => {
                primary => {
                    numeric => 1,
                },
            },
            use_groups  => ['conversion'],
            modifiers   => ['conversion to (numeric)'],
            ignore      => qr/\d+/i,
        },
        'Conversion from' => {
            use_options => ['from'],
            use_groups  => ['conversion'],
            modifiers   => ['conversion from'],
            ignore      => qr/^translate/i,
        },
        'Conversion bidirectional' => {
            use_options => ['to', 'from'],
            use_groups  => ['conversion'],
            modifiers   => ['conversion from', 'conversion to'],
            ignore      => qr/^translate| (to|in) /i,
        },
    );

    subtest 'Command' => wi_tests(
        'Command (only command)' => {
            use_options => ['command'],
            use_groups  => ['command'],
            modifiers   => ['prefix command', 'postfix command (command)'],
        },
        'Command (command + postfix)' => {
            use_options => ['command', 'postfix_command'],
            use_groups  => ['command'],
            modifiers   => ['prefix command', 'command (postfix)'],
        },
        'Command (only prefix)' => {
            use_options => ['prefix_command'],
            use_groups  => ['command'],
            modifiers   => ['prefix command'],
        },
        'Command (only postfix)' => {
            use_options => ['postfix_command'],
            use_groups  => ['command'],
            modifiers   => ['command (postfix)'],
        },
    );

    subtest 'Property' => wi_tests(
        'Property' => {
            use_options => ['property'],
            use_groups  => ['property'],
            modifiers   => ['property (property plural)',
                            'property (property singular)'],
        },
        'Property (singular only)' => {
            use_options => ['singular_property'],
            use_groups  => ['property'],
            modifiers   => ['property (singular)'],
        },
        'Property (plural only)' => {
            use_options => ['plural_property'],
            use_groups  => ['property'],
            modifiers   => ['property (plural)'],
        },
        'Property (singular with property)' => {
            use_options => ['singular_property', 'property'],
            use_groups  => ['property'],
            modifiers   => ['property (singular)',
                            'property (property plural)'],
        },
    );

    subtest 'Matcher::match' => sub {
        my $matcher = WhatIsTester::wi(
            groups  => ['conversion'],
            options => {
                to => qr/lang/i,
            },
        );
        subtest 'does not need to match whole query' => sub {
            my $match = $matcher->match('what is foo in lang t');
            isa_ok($match, 'HASH', 'should return a HASH reference');
            is($match->{primary}, 'foo', 'correct primary');
        };
    };

    subtest 'Expected Failures' => sub {
        subtest 'Invalid Group Combinations' => sub {
            my %invalid_group_sets = (
                "'translation'"   => ['translation'],
                "'language'"      => ['language'],
                "'verb'"          => ['verb'],
                "'language'"      => ['conversion', 'language'],
                "'foo'"           => ['language', 'translation', 'foo'],
                "'bar' and 'foo'" => ['language', 'translation', 'foo', 'bar'],
                "'bar' and 'foo'" => ['foo', 'bar'],
            );
            while (my ($group, $groups) = each %invalid_group_sets) {
                throws_ok { WhatIsTester::wi->( groups => $groups ) }
                        qr/Unused groups $group/,
                        ('Should not be able to assign modifiers with groups ' . join ' and ', @{$groups});
            }
            throws_ok { WhatIsTester::wi->( groups => [] ) }
                        qr/No groups specified/,
                        ('Should not accept empty groups');
        };
        subtest 'Required Options' => sub {
            my %invalid_option_sets = (
                "'to' or 'from'" => [['conversion'],
                                     ['translation', 'language']],
                "'prefix_command' or 'command' or 'postfix_command'" => [['command']],
                "'verb'" => [['translation', 'verb']],
                "'singular_property' or 'property' or 'plural_property'" => [['property']],
            );
            while (my ($req_option, $groupss) = each %invalid_option_sets) {
                foreach my $groups (@{$groupss}) {
                    throws_ok { WhatIsTester::wi->( groups => $groups ) }
                            (($req_option =~ /\bor\b/) ? qr/requires at least one of the $req_option options/
                            : qr/requires the $req_option option/),
                            "Groups [@{[join ', ', @{$groups}]}] should require the $req_option option to be set";
                }
            }
        }
    }
};

done_testing;
