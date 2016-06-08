#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw(pairs);
use Regexp::Common;
use Test::Most;

use DDG::GoodieRole::Dates::Match;

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

        my @example_time_oclock = map {
            $_ => [
                { hour => $_ =~ s/\D//gr },
                $_, $_ =~ s/\D//gr
            ]
        } (
            "5 o'clock", '3 oclock',
            "12 o' clock", "1o'clock",
        );

        my @example_day_of_month_allow_single
            = ($simple_named->(day_of_month => '1'),
                @example_day_of_month,
        );

        my @example_month_allow_single = (
            $simple_named->(month => '1'),
            @example_month,
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
            '$RE{date}{dom}{-pad=>"0?"}' => [
                \@example_day_of_month_allow_single,
                [ ' 1', '0' ],
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
            '$RE{date}{month}{-pad=>"0?"}' => [
                \@example_month_allow_single,
                [ '0', '13', ' 1' ],
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
            '$RE{time}{hour}{12}{-oclock=>1}' => [
                \@example_time_oclock,
                [ "13 o'clock", @example_time_12h, "0 o'clock" ],
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

done_testing;

1;
