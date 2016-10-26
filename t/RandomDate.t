#!/usr/bin/env perl

use strict;
use warnings;
use Test::Deep;
use Test::More;
use DDG::Test::Goodie;
use DDG::Test::Language;
use Test::MockTime qw(set_fixed_time);

zci answer_type => "random_date";
zci is_cached   => 0;

my %MAX = (
    Date            => 'Dec 31, 9999',
    'Date and Time' => 'Dec 31, 9999, 11:59:59 PM',
);

my %MIN = (
    Date            => 'Jan 1, 0',
    'Date and Time' => 'Jan 1, 0, 12:00:00 AM',
);

my %NOW = (
    Date  => 'Jan 1, 2000',
);

sub build_subtitle {
    my %options = @_;
    my $type = $options{type};
    my $range_text = $MAX{$type} ?
        " between $options{min} and $options{max}" : '';
    $options{is_standard}
        ? "Random $options{type}$range_text"
        : "Random date for: $options{format}";
}

sub build_structured_answer {
    my %options = @_;
    return $options{match},
        structured_answer => {

            data => {
              title    => $options{match},
              subtitle => $options{subtitle},
            },

            templates => {
                group => "text",
            }
        };
}

sub build_test {
    my %options = @_;
    $options{is_standard} //= 1;
    $options{min} //= $MIN{$options{type}} // '';
    $options{max} //= $MAX{$options{type}} // '';
    $options{match}    = re(qr/^$options{match}$/);
    $options{subtitle} = build_subtitle(%options);
    test_zci(build_structured_answer(%options))
}

sub language_test {
    my ($code, $query, %test_params) = @_;
    my $lang = test_language($code);
    DDG::Request->new(
        language  => $lang,
        query_raw => $query
    ) => build_test(%test_params);
}

my $time_24 = qr/\d{2}:\d{2}:\d{2}/;
my $time_12 = qr/\d{1,2}:\d{2}:\d{2} [AP]M/;
my $time_12_my = qr/\d{1,2}:\d{2}:\d{2} PT?G/;
my $short_name = qr/[A-Z][a-z]{2}/;
my $long_name = qr/[A-Z][a-z]{2,}/;
my $week = qr/\d{2}/;
my $day_en = qr/Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday/;
my $day_my = qr/Isnin|Khamis|Jumaat|Ahad|Sabtu|Rabu|Selasa/;
my $year = qr/\d{1,4}/;
my $day_of_month = qr/\d{1,2}/;
my $month_of_year = qr/\d{2}/;
my $month_letter = qr/[JFMASOND]/;

set_fixed_time('2000-01-01T00:00:00');

my %type_matches = (
    '12-hour Time'    => $time_12,
    '24-hour Time'    => $time_24,
    'Date'            => "$short_name $day_of_month, $year",
    'Date and Time'   => "$short_name $day_of_month, $year, $time_12",
    'Day of the Week' => qr/\d/,
    'Day of the Year' => qr/\d{3}/,
    'ISO-8601 Date'   => "$year-$month_of_year-$day_of_month",
    'Month'           => $long_name,
    'Time'            => $time_12,
    'Week'            => $week,
    'Weekday'         => $day_en,
);

sub build_format_test {
    my ($format, $re) = @_;
    build_test(
        type   => 'format',
        format => $format,
        match  => $re,
        is_standard => 0,
    );
}

sub build_standard_test {
    my %options = @_ == 1 ? (type => $_[0]) : @_;
    build_test(
        %options,
        match => $type_matches{$options{type}},
    );
}

sub build_range_test {
    my ($type, $min, $max) = @_;
    $max = $MAX{$type} if $max eq 'max';
    $min = $MIN{$type} if $min eq 'min';
    $max = $NOW{$type} if $max eq 'now';
    $min = $NOW{$type} if $min eq 'now';
    build_standard_test(
        type => $type,
        min  => $min,
        max  => $max,
    );
}

ddg_goodie_test(
    [qw( DDG::Goodie::RandomDate )],
    # strftime Formats
    'random date for %Y'  => build_format_test('%Y', qr/$year/),
    'date for %a, %b %T'  => build_format_test('%a, %b %T', qr/$short_name, $short_name $time_24/),
    'example date for %a' => build_format_test('%a', qr/$short_name/),
    # CLDR Formats
    'date for MMMM'        => build_format_test('MMMM', $long_name),
    'date for MMMd'        => build_format_test('MMMd', "$short_name$day_of_month"),
    'date for EEEE, MMMMM' => build_format_test('EEEE, MMMMM', "$day_en, $month_letter"),
    'date for %K (cldr)'   => build_format_test('%K', qr/%\d{1,2}/),
    'date for %m (cldr)'   => build_format_test('%m', qr/%\d{1,2}/),
    # 'Standard' Queries
    'random weekday'         => build_standard_test('Weekday'),
    'random month'           => build_standard_test('Month'),
    'random time'            => build_standard_test('Time'),
    'random 12-hour time'    => build_standard_test('12-hour Time'),
    'random 24-hour time'    => build_standard_test('24-hour Time'),
    'random week'            => build_standard_test('Week'),
    'random datetime'        => build_standard_test('Date and Time'),
    'random day of the week' => build_standard_test('Day of the Week'),
    'random day of the year' => build_standard_test('Day of the Year'),
    'random iso-8601 date'   => build_standard_test('ISO-8601 Date'),
    # Other locales
    language_test('my', 'random time',
        type  => 'Time',
        match => $time_12_my,
    ),
    language_test('my', 'random day',
        type  => 'Weekday',
        match => $day_my,
    ),
    language_test('my', 'random date for EEEE',
        type        => 'format',
        format      => 'EEEE',
        match       => $day_my,
        is_standard => 0,
    ),
    # With HTML
    'random date for <p>%a</p>' => build_format_test('<p>%a</p>', qr/<p>$short_name<\/p>/),
    # With ranges
    'random date in the past'   => build_range_test('Date', 'min', 'now'),
    'random past date'          => build_range_test('Date', 'min', 'now'),
    'random date past'          => build_range_test('Date', 'min', 'now'),
    'random date in the future' => build_range_test('Date', 'now', 'max'),
    'random future date'        => build_range_test('Date', 'now', 'max'),
    'random date future'        => build_range_test('Date', 'now', 'max'),
    'random date between 2005-06-10 and 2006-06-11' => build_range_test(
        'Date', 'Jun 10, 2005', 'Jun 11, 2006',
    ),
    'random date between 2005-06-10 and 2005-06-10' => undef,
    'random date between'             => undef,
    'random date between now and bar' => undef,
    'random date between now'         => undef,
    # Not supported
    'random century in the past' => undef,
    # Invalid Queries
    'date for %K'         => undef,
    'date for %{year}'    => undef,
    'date for %Y %{year}' => undef,
    'random number'       => undef,
    'example date'        => undef,
);

done_testing;
