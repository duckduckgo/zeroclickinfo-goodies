#!/usr/bin/env perl

use strict;
use warnings;

use Test::MockTime qw( :all );
use Test::Most;

use DDG::Test::Location;
use DDG::Test::Language;

use List::Util qw(pairs);

use Regexp::Common;

{ package DatesRoleTester; use Moo; with 'DDG::GoodieRole::Dates'; 1; }

subtest 'Initialization' => sub {
    new_ok('DatesRoleTester', [], 'Applied to a class');
};

my $date_parser = DatesRoleTester::date_parser();
isa_ok($date_parser, 'DDG::GoodieRole::Dates::Parser', 'main date parser');

subtest format_spec_to_regex => sub {
    subtest '^$ anchored matches' => sub {
        my $simple_named = sub {
            my ($name, @cases) = @_;
            return map { $_ => [ { $name => $_ }, $_ ] } @cases;
        };
        my @example_full_weekday
            = $simple_named->(qw(weekday Monday tuesday));
        my @example_month_full
            = $simple_named->(qw(month January february));
        my @example_date_slash   = (
            '12/13/14' => [
                { year => 14, month => 12, day_of_month => 13 },
                '12/13/14', '12', '13', '14'
            ],
            '01/09/16' => [
                { year => 16, month => '01',
                    day_of_month => '09' },
                '01/09/16', '01', '09', '16'
            ],
        );
        my @example_full_date    = (
            '2014-12-13' => [
                { year => '2014', month => '12',
                    day_of_month => '13' },
                '2014-12-13', '2014', '12', '13'
            ],
            '2016-01-09' => ['2016-01-09', '2016', '01', '09'],
        );
        my @example_hour
            = $simple_named->(qw(hour 00 23));
        my @example_hour_12
            = $simple_named->(qw(hour 01 12));
        my @example_minute
            = $simple_named->(qw(minute 00 59));
        my @example_second
            = $simple_named->(qw(second 00 60));
        my @example_time         = (
            '00:00:00' => ['00:00:00', '00', '00', '00'],
            '23:59:58' => [
                { hour => 23, minute => 59, second => 58 },
                '23:59:58', '23', '59', '58'
            ],
        );
        my @example_year
            = $simple_named->(qw(year 0000 9999 2000));
        my @example_alphabetic_time_zone_abbreviation
            = $simple_named->(qw(time_zone UTC BST));

        my @example_abbreviated_weekday
            = $simple_named->(weekday => 'Thu', 'fri');
        my @example_abbreviated_month
            = $simple_named->(month => 'Jan', 'feb');
        my @example_date_default
            = ('Thu Mar  3 23:05:25 2005');
        my @example_day_of_month
            = $simple_named->(qw(day_of_month 01 31 20));
        my @example_day_of_month_space_padded
            = $simple_named->(day_of_month => ' 1', '17');
        my @example_month
            = $simple_named->(qw(month 01 12 07));
        my @example_am_pm
            = $simple_named->(qw(am_pm AM PM am));
        my @example_time_12h = (
            '11:59:58 AM' => [
                '11:59:58 AM', '11:59:58',
                '11', '59', '58', 'AM',
            ],
            '01:00:00 PM' => [
                '01:00:00 PM',
                '01:00:00', '01', '00', '00', 'PM',
            ],
        );
        my @example_year_last_two_digits
            = $simple_named->(qw(year 99 00 22));
        my @example_hhmm_numeric_time_zone = (
            '+0000' => ['+0000', '+', '0000'],
            '-1800' => ['-1800', '-', '1800'],
        );

        my @example_day_of_month_natural
            = $simple_named->(day_of_month =>
            '1st', '2nd', '3rd', '4th', '5th',
            '11th', '21st', '22nd', '23rd', '24th',
        );

        my @example_day_of_month_allow_single
            = $simple_named->(day_of_month =>
            @example_day_of_month, '1',
        );

        my @example_month_allow_single
            = $simple_named->(month =>
            @example_month, '1',
        );

        my %tcs_re = (
            '$RE{date}{dom}' => [
                \@example_day_of_month,
                [ '1', '32', '00' ],
            ],
            '$RE{date}{dom}{-pad=>" "}' => [
                \@example_day_of_month_space_padded,
                [ '1', '32', '00', ' 0' ],
            ],
            '$RE{date}{dom}{natural}' => [
                \@example_day_of_month_natural,
                [
                    @example_day_of_month_allow_single,
                    '32nd', '0th',
                ],
            ],
            '$RE{date}{formatted}{default}' => [
                \@example_date_default,
                [ '2nd Jan 2013', '2016-01-01' ],
            ],
            '$RE{date}{formatted}{full}' => [
                \@example_full_date,
                [ '2014-13-12', '2016-1-09' ],
            ],
            '$RE{date}{formatted}{slash}' => [
                \@example_date_slash,
                [ '13/12/14', '1/09/16' ],
            ],
            '$RE{date}{month}' => [
                \@example_month,
                [ '00', '1', '13' ],
            ],
            '$RE{date}{month}{abbrev}{-i}' => [
                \@example_abbreviated_month,
                \@example_month_full,
            ],
            '$RE{date}{month}{full}{-i}' => [
                \@example_month_full,
                \@example_abbreviated_month,
            ],
            '$RE{date}{weekday}{abbrev}{-i}' => [
                \@example_abbreviated_weekday,
                \@example_full_weekday,
            ],
            '$RE{date}{weekday}{full}{-i}' => [
                \@example_full_weekday,
                \@example_abbreviated_weekday,
            ],
            '$RE{date}{year}{end}' => [
                \@example_year_last_two_digits,
                [@example_year, '2'],
            ],
            '$RE{date}{year}{full}' => [
                \@example_year,
                [ '123', '10000' ],
            ],
            '$RE{time}{12}' => [
                \@example_time_12h,
                [ '13:00:00 PM', '11:00:00', '11:00 PM', '11:00' ],
            ],
            '$RE{time}{24}' => [
                \@example_time,
                [ '24:00:00', '11:00', '11:00:00:00' ],
            ],
            '$RE{time}{am_pm}{-i}' => [
                \@example_am_pm,
                [ 'a.m', 'P.M.', 'ampm' ],
            ],
            '$RE{time}{hour}{12}' => [
                \@example_hour_12,
                [ '00', '13', '7' ],
            ],
            '$RE{time}{hour}{24}' => [
                \@example_hour,
                [ '24', '7' ],
            ],
            '$RE{time}{minute}' => [
                \@example_minute,
                [ '60', '7' ],
            ],
            '$RE{time}{second}' => [
                \@example_second,
                [ '61', '7' ],
            ],
            '$RE{time}{zone}{abbrev}' => [
                \@example_alphabetic_time_zone_abbreviation,
                [ 'abcd', '100', 'ttt' ],
            ],
            '$RE{time}{zone}{offset}' => [
                \@example_hhmm_numeric_time_zone,
                [
                    @example_alphabetic_time_zone_abbreviation,
                    '1111', '+720'
                ],
            ],
        );

        my $check_names = sub {
            my ($format, $to_match, $names) = @_;
            subtest "with {-names} on $to_match" => sub {
                my $with_names = eval( $format . '{-names}' );
                $to_match =~ qr/^$with_names$/;
                while (my ($name, $expected) = each %$names) {
                    is($+{$name}, $expected, "named \$+{$name}");
                }
            };
        };
        my $check_keep = sub {
            my ($format, $to_match, $keeps) = @_;
            my @keeps = @$keeps;
            if (ref $keeps[0] eq 'HASH') {
                my $names = shift @keeps;
                $check_names->($format, $to_match, $names);
            }
            subtest "with {-keep} on $to_match" => sub {
                my $with_keep = eval( $format . '{-keep}' );
                $to_match =~ qr/^$with_keep$/;
                my $i = 1;
                no strict 'refs';
                foreach my $keep (@keeps) {
                    is(${$i}, $keep, "group \$$i");
                } continue {
                    $i++;
                }
                is(${$i}, undef, "group $i should not match");
            };
        };

        while (my ($format, $results) = each %tcs_re) {
            subtest "spec: $format" => sub {
                my ($valids, $invalids) = @$results;
                my $matcher = eval $format; # Yeah, yeah...
                isa_ok($matcher, 'Regexp::Common', "eval $format");
                $matcher = qr/^$matcher$/;
                if (List::Util::any { ref $_ eq 'ARRAY' } @$valids) {
                    foreach (pairs @$valids) {
                        my ($match, $keeps) = @$_;
                        cmp_deeply($match, re($matcher), "matches $match");
                        $check_keep->($format, $match, $keeps);
                    }
                } else {
                    foreach my $valid (@$valids) {
                        cmp_deeply($valid, re($matcher), "matches $valid");
                        $check_keep->($format, $valid, [$valid]);
                    }
                }
                foreach my $invalid (@$invalids) {
                    cmp_deeply($invalid, none(re($matcher)), "does not match $invalid");
                }
            }
        }
    };
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
        # '13/12/2011'        => 1323734400,     #DMY
        # '01/01/2001'        => 978307200,      #Ambiguous, but valid
        '29 June 2014'      => 1404000000,     #DMY
        '05 Mar 1990'       => 636595200,      #DMY (short)
        'June 01 2012'      => 1338508800,     #MDY
        'May 05 2011'       => 1304553600,     #MDY
        'may 01 2010'       => 1272672000,
        '1st june 1994'     => 770428800,
        # '06/01/2014'        => 1401580800,
        '5 th january 1993' => 726192000,
        'JULY 4TH 1976'     => 205286400,
        # '07/13/1984'        => 458524800,
        # '7/13/1984'         => 458524800,
        # '13/07/1984'        => 458524800,
        # '13.07.1984'        => 458524800,
        # '7.13.1984'         => 458524800,
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
        my $date_object = $date_parser->parse_datestring_to_date($test_date);
        isa_ok($date_object, 'DateTime', $test_date);
        my $date_epoch;
        lives_ok { $date_epoch = $date_object->epoch };
        is($date_epoch, $dates_to_match{$test_date}, "$test_date has epoch $dates_to_match{$test_date}");
    }
};

subtest 'Working single dates with locale' => sub {
    my %dates_to_match = (
        my => {
            # HTTP
            'Sab, 09 Ogo 2014 18:20:00' => 1407579600,
            # RFC850
            '08-Feb-94 14:15:29 GMT' => 760716929,
            # date(1) default
            'Ahd Sep  7 15:57:56 EST 2014' => 1410123476,
            'Ahd Sep  7 15:57:56 EDT 2014' => 1410119876,
            'Ahd Sep 14 15:57:56 UTC 2014' => 1410710276,
            'Ahd Sep 7 20:11:44 CET 2014'  => 1410117104,
            'Ahd Sep 7 20:11:44 BST 2014'  => 1410117104,
            # RFC 2822
            'Sab, 13 Mac 2010 11:29:05 -0800' => 1268508545,
            # HTTP (without day) - any TZ
            # %d %b %Y %H:%M:%S %Z
            '01 Jan 2012 00:01:20 UTC' => 1325376080,
            '22 Jun 1998 00:00:02 GMT' => 898473602,
            '07 Sep 2014 20:11:44 CET' => 1410117104,
            '07 Sep 2014 20:11:44 cet' => 1410117104,
            '09 Ogo 2014 18:20:00'     => 1407579600,
            # Undefined/Natural formats:
            # '13/12/2011'        => 1323705600,
            # '01/01/2001'        => 978278400,
            '29 Jun 2014'      => 1403971200,
            'Mei 05 2011'       => 1304524800,
            'mei 05 2011'       => 1304524800,
            '1st jun 1994'     => 770400000,
            # '06/01/2014'        => 1401580800,
            '5 th januari 1993' => 726163200,
            'JULAI 4TH 1976'     => 205259400,
            'Jun 01 2012'      => 1338480000,
            'jun-01-2012'      => 1338480000,
            'jun/01/2012'       => 1338480000,
            '01-jun-2012'       => 1338480000,
            '01/jun/2012'      => 1338480000,
            'JUN-1-2012'        => 1338480000,
            '4-jUL-1976'        => 205259400,
            '2001-1-1'          => 978278400,
            'jan 6, 2014'       => 1388937600,
            '6, jan 2014'       => 1388937600,
            '6 jan, 2014'       => 1388937600,
            '29 feb, 2012'      => 1330444800,
            '2038-01-20'        => 2147529600,     # 32-bit signed int UNIX epoch ends 2038-01-19
            '1800-01-20'        => -5363045206,    # Way before 32-bit signed int epoch
        },
    );

    my $tester = sub {
        my ($parser, $dates) = @_;
        my %dates_to_match = %$dates;
        foreach my $test_date (sort keys %dates_to_match) {
            my $date_object = $parser->parse_datestring_to_date($test_date);
            isa_ok($date_object, 'DateTime', $test_date);
            my $date_epoch;
            lives_ok { $date_epoch = $date_object->epoch };
            is($date_epoch, $dates_to_match{$test_date}, "$test_date has epoch $dates_to_match{$test_date}");
        }
    };
    while (my ($code, $test_data) = each %dates_to_match) {
        date_locale_test($code, $tester, $test_data);
    };
};

subtest 'Working multi-dates' => sub {
    my %date_sets = (
        'us (language only)' => [
            {
                src    => ['01/10/2014', '01/06/2014', 'today'],
                output => [1389312000,   1388966400, 1451606400],     # 10 jan; 6 jan
            },
            {
                src    => ['01/13/2014', '01/06/2014'],
                output => [1389571200,   1388966400],     # 13 jan; 6 jan
            },
            # {
            #     src    => ['05/06/2014', '20/06/2014'],
            #     output => [1401926400,   1403222400],     # 5 jun; 20 jun
            # },
            # {
            #     src    => ['20/06/2014', '05/06/2014'],
            #     output => [1403222400,   1401926400],     # 20 jun; 5 jun
            # },
            # {
            #     src    => ['5/06/2014', '20/06/2014'],
            #     output => [1401926400,  1403222400],      # 5 jun; 20 jun
            # },
            # {
            #     src    => ['20/06/2014', '5/06/2014'],
            #     output => [1403222400,   1401926400],     # 20 jun; 5 jun
            # },
        ],
        'de (language only)' => [
            {
                src    => ['20.06.2014', '05.06.2014'],
                output => [1403222400,   1401926400],     # 20 jun; 5 jun
            },
            {
                src    => ['05.06.2014', '20.06.2014'],
                output => [1401926400,  1403222400],      # 5 jun; 20 jun
            },
            {
                src    => ['5.Juni.2014', '20.06.2014'],
                output => [1401926400,    1403222400],     # 5 jun; 20 jun
            },
            {
                src    => ['05.06.2014', '4th Januar 2013', '20.06.2014'],
                output => [1401926400,  1357257600,         1403222400],     # 5 jun; 4 jan, 20 jun
            },
            {
                src    => ['11.07.2015', 'last august'],
                output => [1436572800,  1438387200],     # 11 jul; aug 1
            },
        ],
    );

    my $tester = sub {
        my ($parser, $date_sets) = @_;
        set_fixed_time('2016-01-01T00:30:00Z');
        foreach my $set (@$date_sets) {
            my @source = @{$set->{src}};
            eq_or_diff([map { $_->epoch } ($parser->parse_all_datestrings_to_date(@source))],
                $set->{output}, '"' . join(', ', @source) . '": dates parsed correctly');
        }
        restore_time();
    };
    test_dates_with_locale($tester, %date_sets);
};

subtest 'Strong dates and vague or relative dates mixed' => sub {
    set_fixed_time('2001-02-05T00:00:00Z');
    my @date_sets = (
#             {
#                 src => ["1990-06-13", "december"],
#                 out => ['1990-06-13T00:00:00', '1990-12-01T00:00:00']
#             },
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
        my @result = $date_parser->parse_all_datestrings_to_date(@source);
        is_deeply(\@result, \@expectation, join(", ", @source));
    }

    restore_time();
};

subtest 'Extracting dates from strings' => sub {
    my %date_combos = (
        us => [
            ['1st Jan 2012', '01/01/2012', '01/02/2012'],
            ['01/02/2013', '1st Feb 2012', 'feb 2012'],
            ['01/01/1000', '01/01/1000', 'tomorrow'],
            ['01/31/1920', '01/31/2000'],
            # ['03/02/98', '10/3/2010'],
        ],
    );
    my $tester = sub {
        my ($parser, $date_combos) = @_;
        my @date_combos = @$date_combos;
        foreach my $combo (@date_combos) {
            my @unparsed_dates = @$combo;
            my $test_name = join ' and ', @unparsed_dates;
            subtest $test_name => sub {
                foreach my $sep (' and ', ' ') {
                    my $expected_remainder = join '', map { $sep } (1..$#unparsed_dates);
                    my $date_string = join $sep, @unparsed_dates;
                    my @dates = $parser->extract_dates_from_string($date_string);
                    my $remainder = $_;
                    is($_, $expected_remainder, "remainder equals $expected_remainder");
                    is(scalar(@dates), scalar(@unparsed_dates),
                        'number of returned dates ('
                        . $#dates
                        . ') should equal number of dates (' . $#unparsed_dates . ')');
                    my @expected_epochs = map { $_->epoch } $parser->parse_all_datestrings_to_date(@unparsed_dates);
                    my @actual_epochs = map { $_->epoch } @dates;
                    is_deeply(\@actual_epochs, \@expected_epochs, "epochs must be equivalent");
                }
            }
        }
    };
    test_dates_with_locale($tester, %date_combos);
};

subtest 'Relative naked months' => sub {

    my %time_strings = (
        "2015-01-13T00:00:00Z" => {
            src    => ['january', 'february'],
            output => ['2015-01-01T00:00:00', '2015-02-01T00:00:00'],
        },
        "2015-02-01T00:00:00Z" => {
            src    => ['january', 'february'],
            output => ['2015-01-01T00:00:00',  '2015-02-01T00:00:00'],
        },
        "2015-03-01T00:00:00Z" => {
            src    => ['january', 'february'],
            output => ['2015-01-01T00:00:00',  '2015-02-01T00:00:00'],
        },
        "2014-12-01T00:00:00Z" => {
            src    => ['next january', 'next february'],
            output => ['2015-01-01T00:00:00',  '2015-02-01T00:00:00'],
        },

    );

    foreach my $query_time (sort keys %time_strings) {
        subtest "relative to $query_time" => sub {
            set_fixed_time($query_time);

            my @source = @{$time_strings{$query_time}{src}};
            my @expectation = @{$time_strings{$query_time}{output}};
            my @result = $date_parser->parse_all_datestrings_to_date(@source);

            is_deeply(\@result, \@expectation, "parse all of @{[join ', ', @source]}");
        }
    }
};

subtest 'Invalid single dates' => sub {
    my @bad_strings_match = (
        '24/8',
        '123',
        '123-84-1',
        '1/1/1',
        '2014-13-13',
        'Feb 38th 2015',
        '2014-02-29',
    );

    foreach my $test_string (sort @bad_strings_match) {
        my $result;
        lives_ok { $result = $date_parser->parse_datestring_to_date($test_string) } '... and does not kill the parser.';
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
        my @date_results = $date_parser->parse_all_datestrings_to_date(@source);
        is(@date_results, 0, '"' . join(', ', @source) . '": cannot be parsed in combination.');
    }
};

subtest 'Valid standard string format' => sub {
    my %date_strings = (
        '01 Jan 2001' => ['2001-1-1',   'January 1st, 2001', '1st January, 2001'],
        # '13 Jan 2014' => ['13/01/2014', '01/13/2014',        '13th Jan 2014'],
    );

    foreach my $result (sort keys %date_strings) {
        foreach my $test_string (@{$date_strings{$result}}) {
            is($date_parser->format_date_for_display($test_string), $result, $test_string . ' normalizes for output as ' . $result);
        }
    }
};
subtest 'Valid clock string format' => sub {
    my %tests = (
        'us, my' => {
            '01 Jan 2012 00:01:20 UTC'   => ['01 Jan 2012 00:01:20 UTC', '01 Jan 2012 00:01:20 utc'],
            '22 Jun 1998 00:00:02 UTC'   => ['22 Jun 1998 00:00:02 GMT'],
            '07 Sep 2014 20:11:44 EST'   => ['07 Sep 2014 20:11:44 EST'],
            '07 Sep 2014 20:11:44 -0400' => ['07 Sep 2014 20:11:44 EDT'],
        },
        us => {
            '09 Aug 2014 18:20:00 EDT'   => ['09 Aug 2014 18:20:00'],
        },
        my => {
            '09 Ogo 2014 18:20:00 MYT'   => ['09 Ogo 2014 18:20:00'],
        },
        de => {
            '09 Aug. 2014 18:20:00 CEST'   => ['09 Aug 2014 18:20:00'],
        },
    );
    my $tester = sub {
        my ($parser, $date_strings) = @_;
        my %date_strings = %$date_strings;
        foreach my $result (keys %date_strings) {
            foreach my $test_string (@{$date_strings{$result}}) {
                is($parser->format_date_for_display($test_string, 1), $result, $test_string . ' normalizes for output as ' . $result);
            }
        }
    };
    while (my ($code, $tc) = each %tests) {
        date_locale_test($code, $tester, $tc);
    };
};
subtest 'Invalid standard string format' => sub {
    my %bad_stuff = (
        'Empty string' => '',
        'Hashref'      => {},
        'Object'       => DatesRoleTester->new,
    );
    foreach my $description (sort keys %bad_stuff) {
        my $result;
        lives_ok { $result = $date_parser->format_date_for_display($bad_stuff{$description}) } $description . ' does not kill the string output';
        is($result, '', '... and yields an empty string as a result');
    }
};
subtest 'Vague strings' => sub {
    my %time_strings = (
        'us (language only)' => {
            '2000-08-01T00:00:00Z' => {
                # Yesterday
                'yesterday'     => '31 Jul 2000',
                'last day'      => '31 Jul 2000',
                'a day ago'     => '31 Jul 2000',
                # Today
                'today'         => '01 Aug 2000',
                'current day'   => '01 Aug 2000',
                'this day'      => '01 Aug 2000',
                'now'           => '01 Aug 2000',
                # Tomorrow
                'a day from now' => '02 Aug 2000',
                'tomorrow'       => '02 Aug 2000',
                'next day'       => '02 Aug 2000',
                'in a day'       => '02 Aug 2000',
                # Back in time
                '3 days before today'      => '29 Jul 2000',
                '2 weeks ago'              => '18 Jul 2000',
                'a month previous'         => '01 Jul 2000',
                'a year previous to today' => '01 Aug 1999',
                # Forward in time
                '2 days from now'   => '03 Aug 2000',
                '2 days from today' => '03 Aug 2000',
                # Recursive
                '3 weeks after today'                 => '22 Aug 2000',
                '3 days before 3 days after now'      => '01 Aug 2000',
                'a day before a day before yesterday' => '29 Jul 2000',
                'a day before 31 December'            => '30 Dec 2000',
                'a day before 2012-01-02'             => '01 Jan 2012',
                'the day after tomorrow'              => '03 Aug 2000',
                'in the year'                         => undef,
                '1440 minutes from now'               => '02 Aug 2000',
                '1440 minutes from 1st jan'           => '02 Jan 2000',
                # Multiple units
                '3 days and a week after 01/01/2012'      => '11 Jan 2012',
                '3 days and a week after today'           => '11 Aug 2000',
                '2 months, 2 weeks and 2 days from today' => '17 Oct 2000',

                # Month upcoming
                'next december' => '01 Dec 2000',
                # Month already passed
                'last january'  => '01 Jan 2000',
                'next jan'      => '01 Jan 2001',
                '1 Jan'         => '01 Jan 2000',
                'jan'           => '01 Jan 2001',
                # Previous June closer than next June
                'june'          => '01 Jun 2000',
                # Month current
                'august'        => '01 Aug 2000',
                'aug'           => '01 Aug 2000',

                'this year'     => '01 Jan 2000',
                'december 2015' => '01 Dec 2015',
                'june 2000'     => '01 Jun 2000',
                'feb 2038'      => '01 Feb 2038',
                'next day'      => '02 Aug 2000',
            },
            '2015-12-01T00:00:00Z' => {
                # Month upcoming
                # Month current
                'next december' => '01 Dec 2016',
                'december'      => '01 Dec 2015',
                # Month already passed
                'last january'  => '01 Jan 2015',
                'june'          => '01 Jun 2016',
                'jan'           => '01 Jan 2016',
                'next jan'      => '01 Jan 2016',

                'december 2015' => '01 Dec 2015',
                'june 2000'     => '01 Jun 2000',
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
                'next month'        => '01 Nov 2014',
                'this month'        => '01 Oct 2014',
                'last month'        => '01 Sep 2014',
                'next year'         => '01 Jan 2015',
                'this year'         => '01 Jan 2014',
                'last year'         => '01 Jan 2013',
                'december 2015'     => '01 Dec 2015',
                'march 13'          => '13 Mar 2014',
                'in a weeks time'   => '15 Oct 2014',
                '2 months ago'      => '08 Aug 2014',
                'in 2 years'        => '08 Oct 2016',
                'a week ago'        => '01 Oct 2014',
                'a month ago'       => '08 Sep 2014',
                'in 2 days'         => '10 Oct 2014'
            },
        },
        'de (language only)' => {
            '2015-12-01T00:00:00Z' => {
                'next dezember' => '01 Dez. 2016',
                'last januar'   => '01 Jan. 2015',
                'juni'          => '01 Juni 2016',
                'dezember'      => '01 Dez. 2015',
                'dezember 2015' => '01 Dez. 2015',
                'juni 2000'     => '01 Juni 2000',
                'jan'           => '01 Jan. 2016',
                'next jan'      => '01 Jan. 2016',
                'last jan'      => '01 Jan. 2015',
                'feb 2038'      => '01 Feb. 2038',
                'now'           => '01 Dez. 2015',
                'today'         => '01 Dez. 2015',
                'current day'   => '01 Dez. 2015',
                'next month'    => '01 Jan. 2016',
                'this week'     => '01 Dez. 2015',
                '1 month ago'   => '01 Nov. 2015',
                '2 years ago'   => '01 Dez. 2013'
            },
        },
    );
    my $tester = sub {
        my ($parser, $time_strings) = @_;
        my %time_strings = %$time_strings;
        foreach my $query_time (sort keys %time_strings) {
            set_fixed_time($query_time);
            my %strings = %{$time_strings{$query_time}};
            foreach my $test_date (sort keys %strings) {
                my $result = $parser->parse_datestring_to_date($test_date);
                if (my $expected = $strings{$test_date}) {
                    isa_ok($result, 'DateTime', $test_date);
                    is($parser->format_date_for_display($result), $expected, $test_date . ' relative to ' . $query_time);
                } else {
                    is($result, undef, "$test_date is not valid");
                }
            }
        }
    };
    test_dates_with_locale($tester, %time_strings);
    restore_time();
};

subtest 'Valid mixture of formatted and descriptive dates' => sub {
    set_fixed_time('2000-01-01T00:00:00Z');
    my %mixed_dates_to_test = (
        'us (language only)' => {
            '2014-11-27'                => 1417046400,
            '1994-02-03T14:15:29'       => 760284929,
            'Sat, 09 Aug 2014 18:20:00' => 1407608400,
            '08-Feb-94 14:15:29 GMT'    => 760716929,
            # '13/12/2011'                => 1323734400,
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
            'december'                  => 944006400,
        },
    );
    my $tester = sub {
        my ($parser, $mixed_dates) = @_;
        my %mixed_dates = %$mixed_dates;
        foreach my $test_mixed_date (sort keys %mixed_dates) {
            my $parsed_date_object = $parser->parse_datestring_to_date($test_mixed_date);
            isa_ok($parsed_date_object, 'DateTime', $test_mixed_date);
            is($parsed_date_object->epoch, $mixed_dates{$test_mixed_date}, ' ... represents the correct time.');
        }
    };
    test_dates_with_locale($tester, %mixed_dates_to_test);
    restore_time();
};

sub test_dates_with_locale {
    my ($tester, %tests) = @_;
    while (my ($code, $tests) = each %tests) {
        date_locale_test($code, $tester, $tests);
    }
};

sub date_locale_test {
    my ($test_code, $test, $test_data) = @_;
    my ($use_language, $use_location) = (1, 1);
    if ($test_code =~ s/ \((language|location) only\)$//) {
        my $use_only = $1;
        $use_language = $use_only eq 'language' ? 1 : 0;
        $use_location = $use_only eq 'location' ? 1 : 0;
    }
    my @codes = $test_code eq 'all'
        ? ('de', 'us', 'my') : split ', ', $test_code;
    foreach my $code (@codes) {
        subtest "with locale code: $code" => sub {
            my $test_location = test_location($code) if $use_location;
            my $test_language = test_language($code) if $use_language;
            {
                package DDG::Goodie::FakerDaterLanger;
                use Moo;
                with 'DDG::GoodieRole::Dates';
                our $loc = $test_location;
                our $lang = $test_language;
                sub parser { shift; return date_parser(); };
                1;
            };
            my $with_lang = new_ok('DDG::Goodie::FakerDaterLanger', [], 'With language');
            my $parser = $with_lang->parser();
            $test->($parser, $test_data);
        };
    };
}

subtest 'Ambiguous dates with location' => sub {
    my $tester = sub {
        my ($parser, $data) = @_;
        my %dates = %$data;
        while (my ($date, $ok) = each %dates) {
            my $parsed_date_object = $parser->parse_datestring_to_date($date);
            if (defined $ok) {
                isa_ok($parsed_date_object, 'DateTime', "parsed date for $date");
                is($parsed_date_object->epoch, $ok, "correct epoch for $date");
            } else {
                is($parsed_date_object, undef, "should not be able to parse date $date");
            }
        }
    };

    my %dates = (
        us => {
            '11/13/2013' => 1384318800,
            '13/12/2013' => undef,
            '01/01/2013' => 1357016400,
            '1/1/2013'   => 1357016400,
        },
        de => {
            '11.13.2013' => undef,
            '13.12.2013' => 1386889200,
            '01.01.2013' => 1356994800,
            '1.1.2013'   => 1356994800,
        },
        # au => {
        #     '11/13/2013' => undef,
        #     '13/12/2013' => 1386855000,
        #     '01/01/2013' => 1356960600,
        # },
        # my => {
        #     '11.13.2013' => undef,
        #     '13.12.2013' => 1386864000,
        #     '01.01.2013' => 1356969600,
        # },
    );

    while (my ($code, $test_cases) = each %dates) {
        subtest "Amiguous dates with locale: $code"
            => sub { date_locale_test($code, $tester, $test_cases) };
    }
};

subtest 'Relative dates with location' => sub {
    my $tester = sub {
        my $parser = shift;
        set_fixed_time('2013-12-31T23:00:00Z');
        my $today_obj;
        lives_ok { $today_obj = $parser->parse_datestring_to_date('now'); } 'Parsed out today at just before midnight UTC NYE, 2013';
        is($today_obj->time_zone_long_name, 'Asia/Kuala_Lumpur', '... in our local time zone');
        is($today_obj->year,                2014,           '... where it is already 2014');
        is($today_obj->hms,                 '07:00:00',     '... for about 4.5 hours');
        is($today_obj->offset / 3600,       8,            '... which seems just about right.');
        restore_time();
    };
    date_locale_test('my', $tester);
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
};
subtest 'date_parser' => sub {
    subtest 'specifying locale' => sub {
        my $tester = sub {
            my ($parser, $data) = @_;
            my %dates = %$data;
            while (my ($date, $ok) = each %dates) {
                my $parsed_date_object = $parser->parse_datestring_to_date($date);
                if (defined $ok) {
                    isa_ok($parsed_date_object, 'DateTime', "parsed date for $date");
                    is($parsed_date_object->epoch, $ok, "correct epoch for $date");
                } else {
                    is($parsed_date_object, undef, "should not be able to parse date $date");
                }
            }
        };

        my %dates = (
            en_US => {
                '11/13/2013' => 1384300800,
                '13/12/2013' => undef,
                '01/01/2013' => 1356998400,
                '1/1/2013'   => 1356998400,
            },
            de_DE => {
                '11.13.2013' => undef,
                '13.12.2013' => 1386892800,
                '01.01.2013' => 1356998400,
                '1.1.2013'   => 1356998400,
            },
            # au => {
            #     '11/13/2013' => undef,
            #     '13/12/2013' => 1386855000,
            #     '01/01/2013' => 1356960600,
            # },
            # my => {
            #     '11.13.2013' => undef,
            #     '13.12.2013' => 1386864000,
            #     '01.01.2013' => 1356969600,
            # },
        );

        while (my ($code, $test_cases) = each %dates) {
            my $parser = DatesRoleTester::date_parser($code);
            isa_ok($parser, 'DDG::GoodieRole::Dates::Parser', "parser for $code");
            subtest "Amiguous dates with locale: $code"
                => sub { $tester->($parser, $test_cases) };
        }
    };
    subtest 'fallback' => sub {
        subtest 'default fallback (en)' => sub {
            my $parser = DatesRoleTester::date_parser('de_DE');
            isa_ok($parser->parse_datestring_to_date('januar'), 'DateTime', 'native month');
            isa_ok($parser->parse_datestring_to_date('january'), 'DateTime', 'fallback month');
            isa_ok($parser->parse_datestring_to_date('01.01.2012'), 'DateTime', 'locale short format');
            # Actual format is %m/%d/%y - which is the same as %D.
            is($parser->parse_datestring_to_date('13/12/12'), undef, 'en short format');
        };
        subtest 'specifying fallback' => sub {
            my $parser = DatesRoleTester::date_parser('de_DE', 'en_US');
            isa_ok($parser->parse_datestring_to_date('januar'), 'DateTime', 'native month');
            isa_ok($parser->parse_datestring_to_date('january'), 'DateTime', 'fallback month');
            isa_ok($parser->parse_datestring_to_date('01.01.2012'), 'DateTime', 'locale short format');
            is($parser->parse_datestring_to_date('10/10/2010'), undef, 'fallback short format');
        };
        subtest 'multiple fallbacks' => sub {
            my $parser = DatesRoleTester::date_parser('de_DE', 'en_US', 'ms_MY');
            isa_ok($parser->parse_datestring_to_date('januar'), 'DateTime', 'native month');
            isa_ok($parser->parse_datestring_to_date('january'), 'DateTime', 'fallback month');
            isa_ok($parser->parse_datestring_to_date('januari'), 'DateTime', 'second fallback month');
            isa_ok($parser->parse_datestring_to_date('01.01.2012'), 'DateTime', 'locale short format');
            is($parser->parse_datestring_to_date('10/10/2010'), undef, 'fallback short format');
        };
    };
};
subtest 'direction preferences' => sub {
    subtest 'invalid preference' => sub {
        my $parser = DatesRoleTester::date_parser('en');
        dies_ok { $parser->direction_preference('forward') };
    };
    my %tests = (
        '2014-06-01' => {
            prefer_future => {
                jan => '2015-01-01',
                jun => '2014-06-01',
                dec => '2014-12-01',
            },
            prefer_past => {
                jan => '2014-01-01',
                jun => '2014-06-01',
                dec => '2013-12-01',
            },
            prefer_closest => {
                jan => '2014-01-01',
                jun => '2014-06-01',
                dec => '2014-12-01',
            },
        },
    );
    while (my ($fixed_time, $tests) = each %tests) {
        set_fixed_time($fixed_time);
        while (my ($preference, $date_tests) = each %$tests) {
            my $parser = DatesRoleTester::date_parser('en');
            $parser->direction_preference($preference);
            subtest $preference => sub {
                while (my ($date_string, $expected) = each %$date_tests) {
                    subtest $date_string => sub {
                        my $date = $parser->parse_datestring_to_date($date_string);
                        isa_ok($date, 'DateTime', "parsed date: $date_string");
                        is($date->strftime('%F'), $expected, 'iso8601 format');
                    };
                }
            };
        }
        restore_time();
    }
};

done_testing;

1;
