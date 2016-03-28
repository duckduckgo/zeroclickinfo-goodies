package DDG::GoodieRole::Dates;
# ABSTRACT: A role to allow Goodies to recognize and work with dates in different notations.

use strict;
use warnings;

use Moo::Role;

use DateTime;
use Devel::StackTrace;
use List::Util qw( first );
use List::MoreUtils qw( uniq first_index );
use Package::Stash;
use Try::Tiny;
use YAML::XS qw(LoadFile);
use File::Find::Rule;

# This appears to parse most/all of the big ones, however it doesn't present a regex
use DateTime::Format::HTTP;


sub dates_dir {
    my $to_find = shift;
    my @results = File::Find::Rule->name($to_find)->in('lib/DDG/GoodieRole/Dates');
    return $results[0];
}

my $time_formats = LoadFile(dates_dir('time_formats.yaml'));
my %time_formats = %{$time_formats};

my %format_to_standard = map {
    my $std = $_;
    map { $_ => $std } @{$time_formats{$std}->{formats}}
} keys %time_formats;

# Standards in priority order for matching.
my @ordered_standards = uniq map {
    $format_to_standard{$_}
} (keys %format_to_standard);

sub _compare_formats_standards {
    my ($f, $s) = @_;
    return first_index { $format_to_standard{$f} eq $_ } @ordered_standards
        <=> first_index { $format_to_standard{$s} eq $_ } @ordered_standards;
}

my %locale_formats = (
    'en_US' => 'Custom (month-first, ambiguous)',
    'other' => 'Custom (day-first, ambiguous)',
);

my @preferred_locale_order = ('en_US', 'other');

sub get_disallowed_formats {
    my $format = shift;
    return @{$time_formats{$format}->{cannot_combine} || []};
}

my %disallowed_standards = map {
    $_ => get_disallowed_formats($_)
} (values %locale_formats);

sub _cannot_combine_formats {
    my ($f, $s) = @_;
    my @f_std = get_disallowed_formats($f) or return 0;
    my @s_std = get_disallowed_formats($s) or return 0;
    return 1 if first { $f eq $_ } @s_std ||
                first { $s eq $_ } @f_std;
    return 0;
}
my @ordered_formats = sort {
    _cannot_combine_formats($a, $b) ? _compare_formats_standards($a, $b)
    : $a =~ $b ? -1 : $b =~ $a ? 1 : length $b <=> length $a
} (keys %format_to_standard);

# p @ordered_formats;


my $days_months = LoadFile(dates_dir('days_months.yaml'));

my %months = %{$days_months->{months}};
my %weekdays = %{$days_months->{weekdays}};
my %short_month_to_number = map { lc $_->{short} => $_->{numeric} } (values %months);
my @short_days = map { $_->{short} } (values %weekdays);
my @full_days = map { $_->{long} } (values %weekdays);

# Reused lists and components for below
my $short_day_of_week   =  qr/@{[join '|', @short_days]}/i;
my $full_day_of_week    = qr/@{[join '|', @full_days]}/i;
my %full_month_to_short = map { lc $_->{long} => $_->{short} } (values %months);
my %short_month_fix     = map { lc $_ => $_ } (values %full_month_to_short);
my @short_months = map { $_->{short} } (values %months);
my $short_month = qr/@{[join '|', @short_months]}/i;
my @full_months = map { $_->{long} } (values %months);
my $full_month = qr/@{[join '|', @full_months]}/i;
my $month_regex         = qr#$full_month|$short_month#;
my $time_24h            = qr#(?:(?:[0-1][0-9])|(?:2[0-3]))[:]?[0-5][0-9][:]?[0-5][0-9]#i;
my $time_12h            = qr#(?:(?:0[1-9])|(?:1[012])):[0-5][0-9]:[0-5][0-9]\s?(?:am|pm)#i;
my $date_number         = qr#[0-3]?[0-9]#;
my $full_year           = qr#[0-9]{4}#;
my $relative_dates      = qr#
    now | today | tomorrow | yesterday |
    (?:(?:current|previous|next)\sday) |
    (?:next|last|this)\s(?:week|month|year) |
    (?:in\s(?:a|[0-9]+)\s(?:day|week|month|year)[s]?)(?:\stime)? |
    (?:(?:a|[0-9]+)\s(?:day|week|month|year)[s]?\sago)
#ix;

# Covering the ambiguous formats, like:
# DMY: 27/11/2014 with a variety of delimiters
# MDY: 11/27/2014 -- fundamentally non-sensical date format, for americans
my $date_delim              = qr#[\.\\/\,_-]#;
my $ambiguous_dates         = qr#(?:$date_number)$date_delim(?:$date_number)$date_delim(?:$full_year)#i;
my $ambiguous_dates_matches = qr#^(?<m>$date_number)$date_delim(?<d>$date_number)$date_delim(?<y>$full_year)$#i;

# like: 1st 2nd 3rd 4-20,24-30th 21st 22nd 23rd 31st
my $number_suffixes = qr#(?:st|nd|rd|th)#i;

my $tz_yaml = LoadFile(dates_dir('time_zones.yaml'));
my %tz_offsets = %{$tz_yaml};
# Timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations

my $tz_strings = join('|', keys %tz_offsets);
my $tz_suffixes = qr#(?:[+-][0-9]{4})|$tz_strings#i;

my $date_standard = qr#$short_day_of_week $short_month\s{1,2}$date_number $time_24h $tz_suffixes $full_year#i;
my $date_standard_matches = qr#$short_day_of_week (?<m>$short_month)\s{1,2}(?<d>$date_number) (?<t>$time_24h) (?<tz>$tz_suffixes) (?<y>$full_year)#i;

# formats parsed by vague datestring, without colouring
# the context of the code using it
my $descriptive_datestring = qr{
    (?:(?:next|last)\s(?:$month_regex)) |                        # next June, last jan
    (?:(?:$month_regex)\s(?:$full_year)) |                         # Jan 2014, August 2000
    (?:(?:$date_number)\s?$number_suffixes?\s(?:$month_regex)) | # 18th Jan, 01 October
    (?:(?:$month_regex)\s(?:$date_number)\s?$number_suffixes?) | # Dec 25, July 4th
    (?:$month_regex)                                           | # February, Aug
    (?:$relative_dates)                                          # next week, last month, this year
    }ix;

# Used for parse_descriptive_datestring_to_date
my $descriptive_datestring_matches = qr#
    (?:(?<q>next|last)\s(?<m>$month_regex)) |
    (?:(?<m>$month_regex)\s(?<y>$full_year)) |
    (?:(?<d>$date_number)\s?$number_suffixes?\s(?<m>$month_regex)) |
    (?:(?<m>$month_regex)\s(?<d>$date_number)\s?$number_suffixes?) |
    (?<m>$month_regex) |
    (?<r>$relative_dates)
    #ix;

sub numbers_with_suffix {
    my @numbers = @_;
    my @with_suffix = map {
        $_ =~ /1\d$|[04-9]$/ ? $_ . '\s*th'
            : $_ =~ /2$/ ? $_ . '\s*nd'
            : $_ =~ /3$/ ? $_ . '\s*rd'
            : $_ =~ /1$/ ? $_ . '\s*st'
            : undef;
    } @numbers;
    return qr/(?:@{[join '|', @with_suffix]})/i;
}

my @abbreviated_weekdays = map { $_->{short} } (values %weekdays);
# %a
my $abbreviated_weekday = qr/(?:@{[join '|', @abbreviated_weekdays]})/i;
# %b
my $abbreviated_month = qr/(?:@{[join '|', @short_months]})/i;
# %H
my $hour = qr/(?:[01][0-9]|2[0-3])/;
# %M
my $minute = qr/[0-5][0-9]/;
# %S
my $second = qr/(?:[0-5][0-9]|60)/;
# %T
my $time = '%H:%M:%S';
# %Y
my $year = qr/[0-9]{4}/;
# %d
my $day_of_month = qr/(?:0[1-9]|[12][0-9]|3[01])/;
# %$d
my $day_of_month_allow_single = qr/(?:0?[1-9]|[12][0-9]|3[01])/;
# %$D
my $day_of_month_natural = qr/(?:@{[numbers_with_suffix((1..31))]})/;
# %m
my $month = qr/(?:0[1-9]|1[0-2])/;
# %$m
my $month_allow_single = qr/(?:0?[1-9]|1[0-2])/;
# %F
my $full_date = '%Y-%m-%d';
# %z
my $hhmm_numeric_time_zone = qr/[+-]$hour$minute/;
# %Z (currently ignoring case)
my $alphabetic_time_zone_abbreviation = qr/(?:@{[join('|', keys %tz_offsets)]})/i;
# %y
my $year_last_two_digits = qr/[0-9]{2}/;
# %D
my $date_slash = '%m/%d/%y';
# %B
my $month_full = qr/(?:@{[join '|', @full_months]})/i;
# %c
my $date_default = '%a %b  %%d %T %Y';

my %percent_to_regex = (
    '%B' => ['month', $month_full],
    '%D' => $date_slash,
    '%F' => $full_date,
    '%H' => ['hour', $hour],
    '%M' => ['minute', $minute],
    '%S' => ['second', $second],
    '%T' => $time,
    '%Y' => ['year', $year],
    '%Z' => ['time_zone', $alphabetic_time_zone_abbreviation],
    '%a' => $abbreviated_weekday,
    '%b' => ['month', $abbreviated_month],
    '%c' => $date_default,
    '%d' => ['day_of_month', $day_of_month],
    '%m' => ['month', $month],
    '%y' => ['year', $year_last_two_digits],
    '%z' => ['time_zone', $hhmm_numeric_time_zone],
    '%%D' => ['day_of_month', $day_of_month_natural],
    '%%d' => ['day_of_month', $day_of_month_allow_single],
    '%%m' => ['month', $month_allow_single],
);

sub format_spec_to_regex {
    my ($spec, $no_captures) = @_;
    while ($spec =~ /(%(?:%\w|\w))/g) {
        my $sequence = $1;
        if (my $regex = $percent_to_regex{$sequence}) {
            die "Recursive sequence in $sequence" if $regex =~ $sequence;
            if (ref $regex eq 'ARRAY') {
                my ($name, $reg) = @$regex;
                $regex = $no_captures ? $reg : qr/(?<$name>$reg)/;
            }
            $spec =~ s/$sequence/$regex/g;
        } else {
            warn "Unknown format control: $1";
        }
    }
    return undef if $spec =~ /(%(%\w|\w))/;
    return qr/(?:$spec)/;
}

my $formatted_datestring = build_datestring_regex();

# Accessors for useful regexes
sub full_year_regex {
	return $full_year;
}
sub full_month_regex {
    return $full_month;
}
sub short_month_regex {
    return $short_month;
}
sub month_regex {
    return $month_regex;
}
sub full_day_of_week_regex {
    return $full_day_of_week;
}
sub short_day_of_week_regex {
    return $short_day_of_week;
}
sub relative_dates_regex {
    return $relative_dates;
}
sub time_24h_regex {
    return $time_24h;
}
sub time_12h_regex {
    return $time_12h;
}

# Accessors for matching regexes
# These matches are for "in the right format"/"looks about right"
#  not "are valid dates"; expects normalised whitespace
sub datestring_regex {
    return qr#(?:$formatted_datestring|$descriptive_datestring)#i;
}

sub descriptive_datestring_regex {
    return $descriptive_datestring;
}

sub formatted_datestring_regex {
    return $formatted_datestring;
}

sub is_valid_year {
	my ($year) = @_;
	return ($year =~ /^[0-9]{1,4}$/)
		&& (1*$year > 0)
		&& (1*$year < 10000);
}

my %format_to_regex = map {
    my $format = $_;
    my $re = format_spec_to_regex($format);
    die "No regex produced from format $format" unless $re;
    $format => $re;
} @ordered_formats;


# Called once to build $formatted_datestring
sub build_datestring_regex {
    my @regexes = ();

    foreach my $spec (@ordered_formats) {
        my $re = format_spec_to_regex($spec, 1);
        die "No regex produced from spec: $spec" unless $re;
        if (first { $_ eq $re } @regexes) {
            die "Regex redefined for spec: $spec";
        }
        push @regexes, $re;
    }

    my $returned_regex = join '|', @regexes;
    return qr/(?:$returned_regex)/i;
}

# Parses any string that *can* be parsed to a date object
sub parse_datestring_to_date {
    my ($d,$base) = @_;
    my $standard_result = parse_formatted_datestring_to_date($d);
    return $standard_result if defined $standard_result;
    return parse_descriptive_datestring_to_date($d, $base);
}

sub normalize_day_of_month {
    my $dom = shift;
    $dom =~ s/\s*(th|st|nd|rd)$//i;
    return sprintf('%02d', $dom);
}

my %month_to_numeric = map {
    (lc $_->{short} => $_->{numeric},
     lc $_->{long}  => $_->{numeric},
     )
} (values %months);

sub normalize_month {
    my $month = shift;
    my $numeric =
        $month =~ /[a-z]/i ? $month_to_numeric{lc $month} : $month;
    return sprintf('%02d', $numeric);
}

sub normalize_time_zone {
    my $time_zone = shift;
    unless (defined $time_zone) {
        return _get_timezone();
    }
    return uc $time_zone;
}

sub normalize_time {
    my ($hour, $minute, $second) = @_;
    return unless defined ($hour // $minute // $second);
    return "$hour:$minute:$second";
}

sub normalize_year {
    my $year_raw = shift;
    return $year_raw if $year_raw =~ qr/^$year$/;
    return '19' . $year_raw if $year_raw =~ qr/^$year_last_two_digits$/;
    return;
}

sub normalize_date_attributes {
    my %raw = @_;
    my $day       = normalize_day_of_month($raw{day_of_month});
    my $month     = normalize_month($raw{month});
    my $time      = normalize_time($raw{hour}, $raw{minute}, $raw{second});
    my $time_zone = normalize_time_zone($raw{time_zone});
    my $year      = normalize_year($raw{year});
    return (
        day_of_month     => $day,
        month            => $month,
        time             => $time,
        time_zone        => $time_zone,
        time_zone_offset => $tz_offsets{$time_zone},
        year             => $year,
    );
}

sub _get_date_match {
    my ($re, $date) = @_;
    return %+ if $date =~ qr/^$re$/;
    return;
}

# Accepts a string which looks like date per the compiled dates.
# Returns a DateTime object representing that date or `undef` if the string cannot be parsed.
sub _parse_formatted_datestring_to_date {
    my ($d, %options) = @_;

    return unless defined $d && $d =~ qr/^$formatted_datestring$/;

    my $standard;
    my %date_attributes;
    my @disallowed = @{$options{disallowed} || []};

    STD: foreach my $format (@ordered_formats) {
        my $std = $format_to_standard{$format};
        next if first { $_ eq $std } @disallowed;
        my $re = $format_to_regex{$format};
        if (my %match_result = _get_date_match($re, $d)) {
            $standard = $std;
            %date_attributes = normalize_date_attributes(%match_result);
            last;
        }
    }

    return unless defined $standard;
    my $year             = $date_attributes{year};
    my $month            = $date_attributes{month};
    my $day              = $date_attributes{day_of_month};
    my $time             = $date_attributes{time};
    my $time_zone        = $date_attributes{time_zone};
    my $time_zone_offset = $date_attributes{time_zone_offset};

    if (defined $time) {
        $time_zone_offset //= '';
        $d = sprintf('%04d-%02d-%02dT%s%s', $year, $month, $day, $time, $time_zone_offset);
    } else {
        $d = sprintf("%04d-%02d-%02d", $year, $month, $day);
    }

    my $maybe_date_object = try { DateTime::Format::HTTP->parse_datetime($d) };  # Don't die no matter how bad we did with checking our string.
    if (ref $maybe_date_object eq 'DateTime') {
        try { $maybe_date_object->set_time_zone($time_zone) };
        if ($maybe_date_object->strftime('%Z') eq 'floating') {
            $maybe_date_object->set_time_zone(_get_timezone());
        };
    }

    return $maybe_date_object;
}

sub parse_formatted_datestring_to_date {
    my $date = shift;
    return _parse_formatted_datestring_to_date($date);
}

# Attempts to perform a full pass through a set of dates - ambiguous
# matches are resolved by only accepting dates if all dates are
# consistent with one format. Preferential order is determined by
# @preferred_locale_order.
sub parse_all_datestrings_to_date {
    my @dates = @_;

    # We check the preferred locales in order - attempting a full pass
    # through with each.
    LOC_PREFER: foreach my $locale (@preferred_locale_order) {
        my @dates_to_return;
        my @disallowed = get_disallowed_formats($locale_formats{$locale});
        foreach my $date (@dates) {

            if (my $date_res = _parse_formatted_datestring_to_date($date, disallowed => \@disallowed)) {
                push @dates_to_return, $date_res;
                next;
            }
            my $date_object = (
                $dates_to_return[0]
                    ? parse_descriptive_datestring_to_date($date, $dates_to_return[0])
                    : parse_descriptive_datestring_to_date($date)
            );

            next LOC_PREFER unless $date_object;
            push @dates_to_return, $date_object;
        }
        return @dates_to_return;
    }
    return;
}

sub get_timezones {
    return %tz_offsets;
}

sub _get_timezone {
    my $default_tz = 'UTC';    # If any of the below fails for some reason, we'll go with this

    my $tz = try {
        # Dig through how we got here, ignoring
        my $hit = 0;
        # We only care about the most recent caller who is some kinda goodie-looking thing.
        my $frame_filter = sub {
            my $frame_info = shift;
            if (!$hit && $frame_info->{caller}[0] =~ /^DDG::Goodie::/) { $hit++; return 1; }
            else                                                       { return 0; }
        };
        my $trace = Devel::StackTrace->new(
            frame_filter => $frame_filter,
            no_args      => 1,
        );
        my $stash = Package::Stash->new($trace->frame(0)->package);    # Get the package info for our caller.
        ${$stash->get_symbol('$loc')}->time_zone;                      # Give back the time_zone in the $loc variable on their package
    };

    return $tz || $default_tz;
}

# Parses a really vague description and basically guesses
sub parse_descriptive_datestring_to_date {
    my ($string, $base_time) = @_;

    return unless (defined $string && $string =~ qr/^$descriptive_datestring_matches$/);

    $base_time = DateTime->now(time_zone => _get_timezone()) unless($base_time);
    my $month = $+{'m'};           # Set in each alternative match.

    if (my $day = $+{'d'}) {
        return parse_datestring_to_date("$day $month " . $base_time->year());
    } elsif (my $relative_dir = $+{'q'}) {
        my $tmp_date = parse_datestring_to_date("01 $month " . $base_time->year());

        # for "next <month>"
        $tmp_date->add( years => 1) if ($relative_dir eq "next" && DateTime->compare($tmp_date, $base_time) != 1);
        # for "last <month>" if $tmp_date is in the future then we need to subtract a year
        $tmp_date->add(years => -1) if ($relative_dir eq "last" && DateTime->compare($tmp_date, $base_time) != -1);
        return $tmp_date;
    } elsif (my $year = $+{'y'}) {
        # Month and year is the first of that month.
        return parse_datestring_to_date("01 $month $year");
    } elsif (my $relative_date = $+{'r'}) {
        # relative dates, tomorrow, yesterday etc
        my $tmp_date = DateTime->now(time_zone => _get_timezone());
        my @to_add;
        if ($relative_date =~ qr/tomorrow|(?:next day)/) {
            @to_add = (days => 1);
        } elsif ($relative_date =~ qr/yesterday|(?:previous day)/) {
            @to_add = (days => -1);
        } elsif ($relative_date =~ qr/(?<dir>next|last|this) (?<unit>week|month|year)/) {
            my $unit = $+{'unit'};
            my $num = ($+{'dir'} eq 'next') ? 1 : ($+{'dir'} eq 'last') ? -1 : 0;
            @to_add = _util_add_unit($unit, $num);
        } elsif ($relative_date =~ qr/in (?<num>a|[0-9]+) (?<unit>day|week|month|year)/) {
            my $unit = $+{'unit'};
            my $num = ($+{'num'} eq "a" ? 1 : $+{'num'});
            @to_add = _util_add_unit($unit, $num);
        } elsif ($relative_date =~ qr/(?<num>a|[0-9]+) (?<unit>day|week|month|year)(?:[s])? ago/) {
            my $unit = $+{'unit'};
            my $num = ($+{'num'} eq "a" ? 1 : $+{'num'}) * -1;
            @to_add = _util_add_unit($unit, $num);
        }
        # Any other cases which came through here should be today.
        $tmp_date->add(@to_add);
        return $tmp_date;
    } else {
        # single named months
        # "january" in january means the current month
        # otherwise it always means the coming month of that name, be it this year or next year
        return parse_datestring_to_date("01 " . $base_time->month_name() . " " . $base_time->year())
            if normalize_month($base_time->month_name()) eq normalize_month($month);
        my $this_years_month = parse_datestring_to_date("01 $month " . $base_time->year());
        $this_years_month->add(years => 1) if (DateTime->compare($this_years_month, $base_time) == -1);
        return $this_years_month;
    }
}

sub _util_add_unit {
    my ($unit, $num) = @_;
    my @to_add =
        ($unit eq 'day')   ? (days => $num)
      : ($unit eq 'week')  ? (days => 7*$num)
      : ($unit eq 'month') ? (months => $num)
      : ($unit eq 'year')  ? (years  => $num)
      :                      ();
    return @to_add;
}

# Takes a DateTime object (or a string which can be parsed into one)
# and returns a standard formatted output string or an empty string if it cannot be parsed.
sub date_output_string {
    my ($dt, $use_clock) = @_;

    my $ddg_format = "%d %b %Y";    # Just here to make it easy to see.
    my $ddg_clock_format = "%d %b %Y %T %Z"; # 01 Jan 2012 00:00:00 UTC (HTTP without day)
    my $date_format = $use_clock ? $ddg_clock_format : $ddg_format;
    my $string     = '';            # By default we've got nothing.
    # They didn't give us a DateTime object, let's try to make one from whatever we got.
    $dt = parse_datestring_to_date($dt) if (ref($dt) !~ /DateTime/);
    $string = $dt->strftime($date_format) if ($dt);

    return $string;
}

1;
