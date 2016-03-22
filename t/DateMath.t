#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockTime qw( :all );
use DDG::Test::Goodie;
use DDG::Test::Location;

zci answer_type => 'date_math';
zci is_cached   => 0;

sub build_structured_answer {
    my ($result, $input) = @_;
    return $result, structured_answer => {
        id   => 'date_math',
        name => 'Answer',
        meta => {
            signal => 'high',
        },
        data => {
            title    => "$result",
            subtitle => "$input",
        },
        templates => {
            group => 'text',
        },
    };
}

sub build_test { test_zci(build_structured_answer(@_)) }

my @overjan = ('02 Feb 2012', '01 Jan 2012 + 32 days');
my @first_sec = ('02 Jan 2012', '01 Jan 2012 + 1 day');

set_fixed_time("2014-01-12T10:00:00");

sub location_test {
    my ($package, %tests) = @_;
    my $location = test_location('in');
    my @location_tests;
    while (my ($query, $test) = each %tests) {
        push @location_tests, (
            DDG::Request->new(
                query_raw => $query,
                location => $location) => $test);
    };

    return ddg_goodie_test($package, @location_tests);
}


location_test([ qw( DDG::Goodie::DateMath ) ],
    # 2012 Jan tests
    'Jan 1 2012 plus 32 days'       => build_test(@overjan),
    'January 1 2012 plus 32 days'   => build_test(@overjan),
    'January 1, 2012 plus 32 days'  => build_test(@overjan),
    'January 1st 2012 plus 32 days' => build_test(@overjan),
    '32 days from January 1st 2012' => build_test(@overjan),
    # Relative (to today)
    '6 weeks ago'              => build_test('01 Dec 2013', '6 weeks ago'),
    '2 weeks from today'       => build_test('26 Jan 2014', '12 Jan 2014 + 2 weeks'),
    'in 3 weeks'               => build_test('02 Feb 2014', 'In 3 weeks'),
    'date today'               => build_test('12 Jan 2014', 'Today'),
    'January 1st plus 32 days' => build_test('02 Feb 2014', '01 Jan 2014 + 32 days'),
    '5 minutes from now'       => build_test('12 Jan 2014 15:35:00 IST', '12 Jan 2014 15:30:00 IST + 5 minutes'),
    'in 5 minutes'             => build_test('12 Jan 2014 15:35:00 IST', '12 Jan 2014 15:30:00 IST + 5 minutes'),
    'in 5 minutes.'            => build_test('12 Jan 2014 15:35:00 IST', '12 Jan 2014 15:30:00 IST + 5 minutes'),
    'time in 5 minutes'        => build_test('12 Jan 2014 15:35:00 IST', '12 Jan 2014 15:30:00 IST + 5 minutes'),
    'twelve seconds ago'       => build_test('12 Jan 2014 15:29:48 IST', '12 Jan 2014 15:30:00 IST - 12 seconds'),
    '01 Jan + 12 hours'        => build_test('01 Jan 2014 12:00:00 IST', '01 Jan 2014 00:00:00 IST + 12 hours'),
    'date today plus 24 hours' => build_test('13 Jan 2014 15:30:00 IST', '12 Jan 2014 15:30:00 IST + 24 hours'),
    # time form
    'time now'        => build_test('12 Jan 2014 15:30:00 IST', 'Now'),
    'time 3 days ago' => build_test('09 Jan 2014 15:30:00 IST', '3 days ago'),
    # Specifying time
    '01 Jan 2012 00:05:00 - 5 minutes'    => build_test('01 Jan 2012 00:00:00 IST', '01 Jan 2012 00:05:00 IST - 5 minutes'),
    '03 Mar 2015 07:07:07 GMT + 12 hours' => build_test('03 Mar 2015 19:07:07 UTC', '03 Mar 2015 07:07:07 UTC + 12 hours'),
    # Misc
    '1 jan 2014 plus 2 weeks'            => build_test('15 Jan 2014', '01 Jan 2014 + 2 weeks'),
    '2nd Jan 2013 - 3000 seconds'        => build_test('01 Jan 2013 23:10:00 IST', '02 Jan 2013 00:00:00 IST - 3,000 seconds'),
    '2nd Jan 2013 subtract 3000 seconds' => build_test('01 Jan 2013 23:10:00 IST', '02 Jan 2013 00:00:00 IST - 3,000 seconds'),
    # / form
    '1/1/2012 plus 32 days'   => build_test(@overjan),
    '1/1/2012 add 5 weeks'    => build_test('05 Feb 2012', '01 Jan 2012 + 5 weeks'),
    '1/1/2012 PlUs 5 months'  => build_test('01 Jun 2012', '01 Jan 2012 + 5 months'),
    '1/1/2012 PLUS 5 years'   => build_test('01 Jan 2017', '01 Jan 2012 + 5 years'),
    '1 day from 1/1/2012'     => build_test(@first_sec),
    '1/1/2012 plus 1 day'     => build_test(@first_sec),
    '1/1/2012 plus 1 days'    => build_test(@first_sec),
    '01/01/2012 + 1 day'      => build_test(@first_sec),
    '1/1/2012 minus ten days' => build_test('22 Dec 2011', '01 Jan 2012 - 10 days'),
    '1/1/2012 + 1 second'     => build_test('01 Jan 2012 00:00:01 IST', '01 Jan 2012 00:00:00 IST + 1 second'),
    # Plurals
    '3 days ago + 1 second'  => build_test('09 Jan 2014 15:30:01 IST', '09 Jan 2014 15:30:00 IST + 1 second'),
    '3 days ago + 1 seconds' => build_test('09 Jan 2014 15:30:01 IST', '09 Jan 2014 15:30:00 IST + 1 second'),
    # Feb 29
    'Jan 1st 2012 + 59 days' => build_test('29 Feb 2012', '01 Jan 2012 + 59 days'),
    'Jan 1st 2013 + 59 days' => build_test('01 Mar 2013', '01 Jan 2013 + 59 days'),
    # Casing
    '3 Years Ago'          => build_test('12 Jan 2011', '3 years ago'),
    'Time Now + 3 Minutes' => build_test('12 Jan 2014 15:33:00 IST', '12 Jan 2014 15:30:00 IST + 3 minutes'),
    # With wrapping
    'What time will it be in 3 minutes' => build_test('12 Jan 2014 15:33:00 IST', '12 Jan 2014 15:30:00 IST + 3 minutes'),
    'What is the time in 3 minutes'     => build_test('12 Jan 2014 15:33:00 IST', '12 Jan 2014 15:30:00 IST + 3 minutes'),
    'What was the time 3 minutes ago'   => build_test('12 Jan 2014 15:27:00 IST', '12 Jan 2014 15:30:00 IST - 3 minutes'),
    'What date will it be in 3 days'    => build_test('15 Jan 2014', 'In 3 days'),
    'What will the date be in 3 days?'  => build_test('15 Jan 2014', 'In 3 days'),
    'What date is it in 3 days'         => build_test('15 Jan 2014', 'In 3 days'),
    'What time was it 3 days ago'       => build_test('09 Jan 2014 15:30:00 IST', '3 days ago'),
    'What date was it 3 days ago'       => build_test('09 Jan 2014', '3 days ago'),
    'What date was it 3 days ago?'      => build_test('09 Jan 2014', '3 days ago'),
    'What day was it 3 days ago?'       => build_test('09 Jan 2014', '3 days ago'),
    # Specified relative
    'date 21st Jan'     => undef,
    'date January 1st'  => undef,
    'time 22nd April'   => undef,
    'date 3rd Jan 2015' => undef,
    'Jan 1st 2012'      => undef,
    # Should not trigger
    'yesterday'  => undef,
    'today'      => undef,
    'five years' => undef,
    'two months' => undef,
    '2 months'   => undef,
    '5 years'    => undef,
    'time ago'   => undef,
);

done_testing;
