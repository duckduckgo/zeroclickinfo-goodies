package DDG::GoodieRole::Dates::Parser;
# ABSTRACT: A role to allow Goodies to recognize and work with dates in different notations.

use strict;
use warnings;

use Moo;
use DateTime;
use Devel::StackTrace;
use File::Find::Rule;
use List::MoreUtils qw( uniq first_index );
use List::Util qw( first );
use Module::Data;
use Package::Stash;
use Path::Class;
use Try::Tiny;
use YAML::XS qw(LoadFile);

BEGIN {
    require Exporter;
    our @ISA = qw(Exporter);
    our @EXPORT = qw( parse_datestring_to_date
                      parse_all_datestrings_to_date
                      extract_dates_from_string
                      format_date_for_display
                      format_to_regex
                      get_timezones
                      );
}



with 'DDG::GoodieRole::NumberStyler';

# This appears to parse most/all of the big ones, however it doesn't present a regex
use DateTime::Format::HTTP;

sub get_dates_path {
    my $target = 'DDG::GoodieRole::Dates';
    my $moddata = Module::Data->new($target);
    my $basedir = $moddata->root->parent;
    my $dates_location = 'lib/DDG/GoodieRole/Dates';
    if ( -e $basedir->subdir($dates_location))  {
        my $dir = dir($basedir, $dates_location);
        return "$dir";
    }
}

my $dates_path = get_dates_path();

sub _dates_dir {
    my $to_find = shift;
    my @results = File::Find::Rule->name("$to_find")->in($dates_path);
    return $results[0];
}

my $time_formats = LoadFile(_dates_dir('time_formats.yaml'));
my %time_formats = %{$time_formats};

my $locale_preferences = LoadFile(_dates_dir('locale_preferences.yaml'));
my %continent_code_preferences = %{$locale_preferences->{continents}};
my %country_to_date_preference;

my %continent_code_to_date_preference = map {
    $_->{code} => $_->{date_format}
} (values %continent_code_preferences);

sub _get_date_format {
    my $loc = _get_loc();
    return 'none' if $loc eq 'none';
    my $date_format;
    if ($date_format = $country_to_date_preference{$loc->country_code}) {
        return $date_format;
    }
    return $continent_code_to_date_preference{$loc->continent_code} || 'none';

}

my %format_to_standard = map {
    my $std = $_;
    map { $_ => $std } @{$time_formats{$std}->{formats}}
} keys %time_formats;

my @default_date_format_order = (
    'MDY',
    'DMY',
);

my %format_to_date_format = map {
    $_ => ($time_formats{$format_to_standard{$_}}->{date_format} || 'none');
} keys %format_to_standard;

sub _compare_formats_date_formats {
    my $a_form = $format_to_date_format{$a};
    my $b_form = $format_to_date_format{$b};
    my $idx_a = first_index { $a_form eq $_ } @default_date_format_order;
    my $idx_b = first_index { $b_form eq $_ } @default_date_format_order;
    my $comp_res = $idx_a <=> $idx_b;
    return $comp_res;
}

my @ordered_formats = sort _compare_formats_date_formats
    sort { length $b <=> length $a } keys %format_to_standard;

my $days_months = LoadFile(_dates_dir('days_months.yaml'));

my %months = %{$days_months->{months}};
my %weekdays = %{$days_months->{weekdays}};
my %short_month_to_number = map { lc $_->{short} => $_->{numeric} } (values %months);
my @short_days = map { $_->{short} } (values %weekdays);
my @full_days = map { $_->{long} } (values %weekdays);


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

my @short_months = map { $_->{short} } (values %months);
my @full_months = map { $_->{long} } (values %months);

my $tz_yaml = LoadFile(_dates_dir('time_zones.yaml'));
my %tz_offsets = %{$tz_yaml};

sub get_timezones {
    return %tz_offsets;
}
# Timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations

my @abbreviated_weekdays = map { $_->{short} } (values %weekdays);
# %a
my $abbreviated_weekday = qr/(?:@{[join '|', @abbreviated_weekdays]})/i;
# %A
my $full_weekday    = qr/(?:@{[join '|', @full_days]})/i;
# %b
my $abbreviated_month = qr/(?<month>@{[join '|', @short_months]})/i;
# %H
my $hour = qr/(?<hour>[01][0-9]|2[0-3])/;
# %M
my $minute = qr/(?<minute>[0-5][0-9])/;
# %S
my $second = qr/(?<second>[0-5][0-9]|60)/;
# %T
my $time = '%H:%M:%S';
# %p
my $am_pm = qr/(?<am_pm>[ap]m)/i;
# %r
my $time_12h = '%I:%M:%S%p';
# I
my $hour_12 = qr/(?<hour>0[1-9]|1[0-2])/;
# %Y
my $year = qr/(?<year>[0-9]{4})/;
# %d
my $day_of_month = qr/(?<day_of_month>0[1-9]|[12][0-9]|3[01])/;
# %%d
my $day_of_month_allow_single = qr/(?<day_of_month>0?[1-9]|[12][0-9]|3[01])/;
# %%D
my $day_of_month_natural = qr/(?<day_of_month>@{[numbers_with_suffix((1..31))]})/;
# %m
my $month = qr/(?<month>0[1-9]|1[0-2])/;
# %%m
my $month_allow_single = qr/(?<month>0?[1-9]|1[0-2])/;
# %F
my $full_date = '%Y-%m-%d';
# %z
my $hhmm_numeric_time_zone = qr/(?<time_zone>[+-]$hour$minute)/;
# %Z (currently ignoring case)
my $alphabetic_time_zone_abbreviation = qr/(?<time_zone>@{[join('|', keys %tz_offsets)]})/i;
# %y
my $year_last_two_digits = qr/(?<year>[0-9]{2})/;
# %D
my $date_slash = '%m/%d/%y';
# %B
my $month_full = qr/(?<month>@{[join '|', @full_months]})/i;
# %c
my $date_default = '%a %b  %%d %T %Y';

my %percent_to_regex = (
    '%B' => $month_full,
    '%D' => $date_slash,
    '%F' => $full_date,
    '%H' => $hour,
    '%I' => $hour_12,
    '%M' => $minute,
    '%S' => $second,
    '%T' => $time,
    '%Y' => $year,
    '%Z' => $alphabetic_time_zone_abbreviation,
    '%a' => $abbreviated_weekday,
    '%b' => $abbreviated_month,
    '%c' => $date_default,
    '%d' => $day_of_month,
    '%m' => $month,
    '%p' => $am_pm,
    '%r' => $time_12h,
    '%y' => $year_last_two_digits,
    '%z' => $hhmm_numeric_time_zone,
    '%%D' => $day_of_month_natural,
    '%%d' => $day_of_month_allow_single,
    '%%m' => $month_allow_single,
);

sub separator_specifier_regex {
    my $format = shift;
    my @formats;
    push @formats, $format =~ s/%%-/-/gr;
    push @formats, $format =~ s|%%-|/|gr;
    push @formats, $format =~ s/%%-/\\./gr;
    push @formats, $format =~ s/%%-/,/gr;
    push @formats, $format =~ s/%%-/_/gr;
    my $seps = join '|', @formats;
    return qr/(?:$seps)/;
}

sub date_format_to_regex {
    my ($format) = @_;
    return format_spec_to_regex($format, 1);
}

sub format_spec_to_regex {
    my ($spec, $no_captures, $no_escape) = @_;
    unless ($no_escape) {
        $spec = quotemeta($spec);
        $spec =~ s/\\( |%|-)/$1/g;
    }
    while ($spec =~ /(%(?:%\w|\w))/g) {
        my $sequence = $1;
        if (my $regex = $percent_to_regex{$sequence}) {
            die "Recursive sequence in $sequence" if $regex =~ $sequence;
            $regex = $no_captures ? neuter_regex($regex) : $regex;
            $spec =~ s/(?<!%)$sequence/$regex/g;
        } else {
            warn "Unknown format control: $1";
        }
    }
    if ($spec =~ /%%-/) {
        $spec = separator_specifier_regex($spec);
    }
    return undef if $spec =~ /(%(%\w|\w))/;
    return qr/(?:$spec)/;
}




# Covering the ambiguous formats, like:
# DMY: 27/11/2014 with a variety of delimiters
# MDY: 11/27/2014 -- fundamentally non-sensical date format, for americans

# like: 1st 2nd 3rd 4-20,24-30th 21st 22nd 23rd 31st
my $number_suffixes = qr#(?:st|nd|rd|th)#i;


my %format_to_regex = map {
    my $format = $_;
    my $re = format_spec_to_regex($format);
    die "No regex produced from format $format" unless $re;
    $format => $re;
} @ordered_formats;

# Called once to build $formatted_datestring
sub _build_formatted_datestring {
    my @regexes = ();

    foreach my $spec (@ordered_formats) {
        my $re = format_spec_to_regex($spec, 0);
        die "No regex produced from spec: $spec" unless $re;
        if (first { $_ eq $re } @regexes) {
            die "Regex redefined for spec: $spec";
        }
        push @regexes, $re;
    }

    my $returned_regex = join '|', @regexes;
    return qr/(?:$returned_regex)/i;
}
my $formatted_datestring_matches = _build_formatted_datestring();
my $formatted_datestring = neuter_regex($formatted_datestring_matches);

has formatted_datestring => (
    is => 'ro',
    default => sub { $formatted_datestring },
);

# Parses any string that *can* be parsed to a date object
sub parse_datestring_to_date {
    my ($date_string, $base) = @_;
    my $standard_result = _parse_formatted_datestring_to_date($date_string);
    return $standard_result if defined $standard_result;
    return _parse_descriptive_datestring_to_date($date_string, $base);
}

sub normalize_day_of_month {
    my $dom = shift;
    return unless defined $dom;
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
    return unless defined $month;
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
    my ($hour, $minute, $second, $am_pm) = @_;
    return unless defined ($hour // $minute // $second);
    $hour += 12 if ($am_pm // '') =~ /pm/i;
    return "$hour:$minute:$second";
}

sub normalize_year {
    my $year_raw = shift;
    return unless defined $year_raw;
    return $year_raw if $year_raw =~ qr/^$year$/;
    return '19' . $year_raw if $year_raw =~ qr/^$year_last_two_digits$/;
    return;
}

sub normalize_date_attributes {
    my %raw = @_;
    my $day       = normalize_day_of_month($raw{day_of_month});
    my $month     = normalize_month($raw{month});
    my $time      = normalize_time($raw{hour}, $raw{minute}, $raw{second}, $raw{am_pm});
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
    my ($datestring, %options) = @_;

    my $d = $datestring;
    return unless defined $d && $d =~ qr/^$formatted_datestring$/;

    my %date_attributes;
    my $locale_format = $options{date_format} // _get_date_format();

    foreach my $format (@ordered_formats) {
        # We'll skip the check if we don't know about the locale format.
        if ($locale_format ne 'none') {
            my $required_date_format = $format_to_date_format{$format};
            next if $required_date_format ne 'none'
                && $required_date_format ne $locale_format;
        }
        my $re = $format_to_regex{$format};
        if (my %match_result = _get_date_match($re, $datestring)) {
            %date_attributes = normalize_date_attributes(%match_result);
            last;
        }
    }

    return unless %date_attributes;

    my $year             = $date_attributes{year};
    my $month            = $date_attributes{month};
    my $day              = $date_attributes{day_of_month};
    my $time             = $date_attributes{time};
    my $time_zone        = $date_attributes{time_zone};
    my $time_zone_offset = $date_attributes{time_zone_offset};

    if (defined $time) {
        $time_zone_offset //= '';
        $d = sprintf('%04d-%02d-%02dT%s%s',
            $year, $month, $day, $time, $time_zone_offset);
    } else {
        $d = sprintf("%04d-%02d-%02d", $year, $month, $day);
    }

    # Don't die no matter how bad we did with checking our string.
    my $maybe_date_object = try { DateTime::Format::HTTP->parse_datetime($d) };
    if (ref $maybe_date_object eq 'DateTime') {
        try { $maybe_date_object->set_time_zone($time_zone) };
        if ($maybe_date_object->strftime('%Z') eq 'floating') {
            $maybe_date_object->set_time_zone(_get_timezone());
        };
    }
    return $maybe_date_object;
}

sub parse_formatted_datestring_to_date {
    my ($self, $date) = @_;
    return _parse_formatted_datestring_to_date($date);
}

# Attempts to perform a full pass through a set of dates - ambiguous
# matches are resolved by only accepting dates if all dates are
# consistent with one format. Preferential order is determined by
# @preferred_locale_order.
sub parse_all_datestrings_to_date {
    my (@dates) = @_;

    # We check the preferred locales in order - attempting a full pass
    # through with each.
    LOC_PREFER: foreach my $date_format (@default_date_format_order) {
        my @dates_to_return;
        foreach my $date (@dates) {

            if (my $date_res = _parse_formatted_datestring_to_date(
                    $date, date_format => $date_format,
                )) {
                push @dates_to_return, $date_res;
                next;
            }
            my $date_object = (
                $dates_to_return[0]
                    ? _parse_descriptive_datestring_to_date($date, $dates_to_return[0])
                    : _parse_descriptive_datestring_to_date($date)
            );

            next LOC_PREFER unless $date_object;
            push @dates_to_return, $date_object;
        }
        return @dates_to_return;
    }
    return;
}

sub _get_timezone {
    my $default_tz = 'UTC';
    my $loc = _get_loc();
    return $default_tz if $loc eq 'none';
    return $loc->time_zone || $default_tz;
}

sub _get_loc {
    _fetch_stash('$loc') or 'none';
}

sub _fetch_stash {
    my $name = shift;

    my $result = try {
        # Dig through how we got here, ignoring
        my $hit = 0;
        # We only care about the most recent caller who is some kinda goodie-looking thing.
        my $frame_filter = sub {
            my $frame_info = shift;
            if (!$hit && $frame_info->{caller}[0] =~ /^DDG::Goodie::/) {
                $hit++;
                return 1;
            }
            else {
                return 0;
            }
        };
        my $trace = Devel::StackTrace->new(
            frame_filter => $frame_filter,
            no_args      => 1,
        );
        # Get the package info for our caller.
        my $stash = Package::Stash->new($trace->frame(0)->package);
        # Give back the $name variable on their package
        ${$stash->get_symbol($name)};
    };
    return $result;
}

my $number_re = number_style_regex();
$number_re = qr/(?<num>a|$number_re)/;

sub neuter_regex {
    my $re = shift;
    $re =~ s/\?<\w+>/?:/g;
    return qr/$re/;
}

my $yesterday = qr/yesterday/i;
my $tomorrow = qr/tomorrow/i;
my $today = qr/(?:now|today)/i;
my $specific_day = qr/(?:$yesterday|$today|$tomorrow)/;

my $unit = qr/(?<unit>second|minute|hour|day|week|month|year)s?/i;
my $neutered_unit = neuter_regex($unit);

my $num_sep = qr/(?:, ?|,? and | )/i;
my $num_unit = qr/(?<num>$number_re|the)\s$unit/i;
my $num_unit_nt = qr/$number_re\s$unit/i;
my $date_amount_modifier = qr/(?<amounts>(?:$num_unit$num_sep)*$num_unit)/i;
my $date_amount_modifier_nt = qr/(?<amounts>(?:$num_unit_nt$num_sep)*$num_unit_nt)/i;

my $forward_direction = qr/(?:next|upcoming)/i;
my $backward_direction = qr/(?:previous|last)/i;
my $static_direction = qr/(?:this|current)/i;
my $direction = qr/(?:$forward_direction|$backward_direction|$static_direction)/i;

my $next_last = qr/(?<dir>$direction) $unit/;
my $neutered_next_last = neuter_regex($next_last);

my $ago = qr/ago|previous|before/i;
my $ago_from_now = qr/$date_amount_modifier\s(?<dir>$ago)/;
my $neutered_ago_from_now = neuter_regex($ago_from_now);

my $in_time = qr/in $date_amount_modifier_nt(?:\stime)?/i;
my $neutered_in = neuter_regex($in_time);

# Reused lists and components for below

my $date_number         = qr#[0-3]?[0-9]#;
my $relative_dates      = qr#
    $specific_day |
    $neutered_next_last |
    $neutered_in |
    $neutered_ago_from_now
#ix;

has relative_datestring => (
    is => 'ro',
    default => sub { $relative_dates },
);

my $units = qr/(?<unit>second|minute|hour|day|week|month|year)s?/i;

my $from_re = qr/in $number_re $units/;

my $month_regex = format_spec_to_regex('%B|%b', 0, 1);
my $day_regex = format_spec_to_regex('%%D|%d|%%d', 0, 1);

# Used for parse_descriptive_datestring_to_date
my $descriptive_datestring_matches = qr#
    (?<q>next|last)\s$month_regex |
    $month_regex\s$year |
    $day_regex\s$month_regex |
    $month_regex\s$day_regex |
    $month_regex |
    (?<r>$relative_dates)
    #ix;

my $ago_rec = qr/ago|previous to|before/i;
my $from_rec = qr/from|after/i;

my $before_after = qr/$date_amount_modifier\s(?<dir>$ago_rec|$from_rec)\s/i;
my $fully_descriptive_regex =
    qr#(?<date>(?<r>$before_after)(?<rec>(?&date)|$formatted_datestring_matches)|
    $descriptive_datestring_matches)#xi;

# formats parsed by vague datestring, without colouring
# the context of the code using it
my $descriptive_datestring = neuter_regex($descriptive_datestring_matches);

has descriptive_datestring => (
    is => 'ro',
    default => sub { $descriptive_datestring },
);

my $neutered_relative_dates = neuter_regex($relative_dates);
my $neutered_before_after = neuter_regex($before_after);

sub _util_add_direction {
    my ($direction, $unit, $amount) = @_;
    return () if $direction =~ $static_direction;
    # These should eventually be handled by NumberStyle
    $amount =~ s/^(?:a|the)$/1/i;
    my $style = number_style_for($amount);
    my $multiplier = $direction =~ /in|from|after|$forward_direction/i
        ? 1 : -1;
    my $num = $style->for_computation($amount) * $multiplier;
    $unit = lc $unit;
    $unit =~ s/s$//;
    my %to_add =
        ($unit eq 'second') ? (seconds => $num)
      : ($unit eq 'minute') ? (minutes => $num)
      : ($unit eq 'hour'  ) ? (hours   => $num)
      : ($unit eq 'day')   ? (days => $num)
      : ($unit eq 'week')  ? (days => 7*$num)
      : ($unit eq 'month') ? (months => $num)
      : ($unit =~ 'year')  ? (years  => $num)
      :                      ();
    return %to_add;
}

sub _util_parse_amounts_to_modifiers {
    my ($direction, $amount_string) = @_;
    my %modifiers;
    while ($amount_string =~ /$num_unit/g) {
        my $amount = $+{num};
        my $unit = $+{unit};
        my ($add_unit, $add_amount) = _util_add_direction($direction, $unit, $amount);
        # Handles weeks as being days, but also allows for multiple
        # occurrences of a single unit type.
        $modifiers{$add_unit} = ($modifiers{$add_unit} // 0) + $add_amount;
    }
    return %modifiers;
}

# Parses a really vague description and basically guesses
sub parse_descriptive_datestring_to_date {
    my ($self, $string, $base_time) = @_;

    return unless (defined $string && $string =~ qr/^$fully_descriptive_regex$/);
    my $relative_date = $+{r};
    my %date_attributes = normalize_date_attributes(%+);

    $base_time = DateTime->now(time_zone => _get_timezone()) unless($base_time);
    my $month = $date_attributes{month}; # Set in each alternative match.
    my $q = $+{'q'};

    my $date;
    if ($relative_date) {
        if (my $rec = $+{rec}) {
            $date = parse_datestring_to_date($rec);
            $relative_date .= 'today';
        } else {
            $date = DateTime->now(time_zone => _get_timezone());
        }
        # relative dates, tomorrow, yesterday etc
        my @to_add;
        if ($relative_date =~ $tomorrow) {
            @to_add = _util_add_direction('next', 'day', 1);
        } elsif ($relative_date =~ $yesterday) {
            @to_add = _util_add_direction('last', 'day', 1);
        } elsif ($relative_date =~ $next_last) {
            @to_add = _util_add_direction($+{dir}, $+{unit}, 1);
        } elsif ($relative_date =~ $in_time) {
            @to_add = _util_parse_amounts_to_modifiers('in', $+{amounts});
        } elsif ($relative_date =~ $before_after) {
            @to_add = _util_parse_amounts_to_modifiers($+{dir}, $+{amounts});
        } elsif ($relative_date =~ $ago_from_now) {
            @to_add = _util_add_direction($+{dir}, $+{unit}, $+{num});
        }
        # Any other cases which came through here should be today.
        $tmp_date->add(@to_add);
        return $tmp_date;
    } elsif (my $day = $date_attributes{day_of_month}) {
        return _parse_formatted_datestring_to_date($base_time->year() . "-$month-$day");
        return parse_datestring_to_date($base_time->year() . "-$month-$day");
    } elsif (my $relative_dir = $q) {
        my $tmp_date = parse_datestring_to_date($base_time->year() . "-$month-01");

        # for "next <month>"
        $tmp_date->add( years => 1) if ($relative_dir eq "next" && DateTime->compare($tmp_date, $base_time) != 1);
        # for "last <month>" if $tmp_date is in the future then we need to subtract a year
        $tmp_date->add(years => -1) if ($relative_dir eq "last" && DateTime->compare($tmp_date, $base_time) != -1);
        return $tmp_date;
    } elsif (my $year = $date_attributes{year}) {
        # Month and year is the first of that month.
        return parse_datestring_to_date("$year-$month-01");
    } else {
        # single named months
        # "january" in january means the current month
        # otherwise it always means the coming month of that name, be it this year or next year
        my $base_month = normalize_month($base_time->month());
        return parse_datestring_to_date($base_time->year() . "-$base_month-01")
            if $base_month eq $month;
        my $this_years_month = parse_datestring_to_date($base_time->year() . "-$month-01");
        $this_years_month->add(years => 1) if (DateTime->compare($this_years_month, $base_time) == -1);
        return $this_years_month;
    }
}

# Takes a DateTime object (or a string which can be parsed into one)
# and returns a standard formatted output string or an empty string if it cannot be parsed.
sub format_date_for_display {
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

sub extract_dates_from_string {
    my ($string) = @_;
    my @dates;
    while ($string =~ /(\b$formatted_datestring\b|$fully_descriptive_regex)/g) {
        my $date = $1;
        $string =~ s/$date//;
        push @dates, $date;
    }
    @dates = parse_all_datestrings_to_date(@dates);
    $_ = $string;
    return @dates;
}

1;
