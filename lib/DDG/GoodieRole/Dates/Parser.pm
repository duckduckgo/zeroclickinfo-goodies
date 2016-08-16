package DDG::GoodieRole::Dates::Parser;
# ABSTRACT: A role to allow Goodies to recognize and work with dates in different notations.

use strict;
use warnings;

use Moo;
use DateTime;
use List::Util qw( any );
use Package::Stash;
use Devel::StackTrace;
use Try::Tiny;
use DateTime::Locale;
use Regexp::Common;

use DDG::GoodieRole::Dates::Match;

BEGIN {
    require Exporter;
    our @ISA = qw(Exporter);
    our @EXPORT = qw();
}

has _locale => (
    is       => 'ro',
    builder  => 1,
    lazy     => 1,
);

has locale => (
    is => 'ro',
);

has datetime_locale => (
    is => 'ro',
    lazy => 1,
    builder => 1,
);

has 'lang' => (
    is      => 'ro',
    default => sub { _get_lang() },
);

has 'loc' => (
    is => 'ro',
    default => sub { _get_loc() },
);

has _time_zone => (
    is => 'ro',
    lazy => 1,
    builder => 1,
);

has fallback_locales => (
    is      => 'ro',
    default => sub { [] },
);

has _fallback_parsers => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

has _use_locale_formats => (
    is      => 'ro',
    default => 1,
);

has direction_preference => (
    is => 'rw',
    default => 'prefer_closest',
    trigger => 1,
);

sub _trigger_direction_preference {
    my $self = shift;
    my $direction = $self->direction_preference;
    my @directions = ('prefer_past', 'prefer_future', 'prefer_closest');
    die "direction_preference must be one of "
        . join(' or ', @directions)
        unless any { $_ eq $direction } @directions;
}

sub _build__fallback_parsers {
    my $self = shift;
    my @fallbacks;
    foreach my $fallback_locale (@{$self->fallback_locales}) {
        my $fallback = DDG::GoodieRole::Dates::Parser->new(
            locale => $fallback_locale,
            _use_locale_formats => 0,
        );
        next if $fallback->datetime_locale->native_language
            eq $self->datetime_locale->native_language;
        push @fallbacks, $fallback;
    }
    return \@fallbacks;
}

sub _build_datetime_locale {
    my $self = shift;
    my $date_locale = DateTime::Locale->load($self->_locale);
}

sub _build__locale {
    my $self = shift;
    my $locale = defined $self->lang ? $self->lang->locale : 'en';
    return $self->locale if defined $self->locale;
    $locale eq '' ? 'en' : $locale;
}

sub _build__time_zone {
    my $self = shift;
    my $tz = defined $self->loc ? $self->loc->time_zone : 'UTC';
    $tz eq '' ? 'UTC' : $tz;
}

with 'DDG::GoodieRole::NumberStyler';

# This appears to parse most/all of the big ones, however it doesn't present a regex
use DateTime::Format::HTTP;

#######################################################################
#                       Formatted Date Strings                        #
#######################################################################

has _formatted_datestring => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

# Called once to build $formatted_datestring
sub _build__formatted_datestring {
    my $self = shift;
    my $locale = $self->_use_locale_formats ? $self->_locale : '';
    return qq/$RE{date}{formatted}{-locale=>$locale}{-names}/;
}

has formatted_datestring => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub _build_formatted_datestring {
    my $self = shift;
    my $locale = $self->_use_locale_formats ? $self->_locale : '';
    return qq/$RE{date}{formatted}{-locale=>$locale}/;
}

# Parses any string that *can* be parsed to a date object
sub parse_datestring_to_date {
    my ($self, $date_string, $base) = @_;
    my $date;
    my $standard_result = $self->_parse_formatted_datestring_to_date($date_string);
    return $standard_result if defined $standard_result;
    $date = $self->_parse_descriptive_datestring_to_date($date_string, $base);
    if (not (defined $date)) {
        foreach my $parser (@{$self->_fallback_parsers}) {
            last if $date = $parser->parse_datestring_to_date($date_string, $base);
        }
    }
    return $date;
}

sub normalize_day_of_month {
    my $dom = shift;
    return unless defined $dom;
    $dom =~ s/\s*(th|st|nd|rd)$//i;
    return sprintf('%02d', $dom);
}

has _month_to_numeric => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub _build__month_to_numeric {
    my $self = shift;
    my $l = $self->datetime_locale;
    my $short = $l->month_stand_alone_abbreviated;
    my $long = $l->month_stand_alone_wide;
    my $short2 = $l->month_format_abbreviated;
    my $long2 = $l->month_format_wide;
    my %month_to_numeric;
    foreach my $months ($short, $long, $short2, $long2) {
        my $i = 1;
        map { $month_to_numeric{lc $_} = $i; $i++ } @$months;
    }
    return \%month_to_numeric;
}

sub normalize_month {
    my ($self, $month) = @_;
    return unless defined $month;
    my $numeric =
        $month =~ /[a-z]/i ? $self->_month_to_numeric->{lc $month} : $month;
    return sprintf('%02d', $numeric);
}

sub normalize_time_zone {
    my $time_zone = shift;
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
    return $year_raw if $year_raw =~ qr/^$RE{date}{year}{full}$/o;
    return '19' . $year_raw if $year_raw =~ qr/^$RE{date}{year}{end}$/o;
    return;
}

sub normalize_date_attributes {
    my ($self, %raw) = @_;
    my $day       = normalize_day_of_month($raw{day_of_month});
    my $month     = $self->normalize_month($raw{month});
    my $time      = normalize_time($raw{hour}, $raw{minute}, $raw{second}, $raw{am_pm});
    my $time_zone = normalize_time_zone($raw{time_zone} // $self->_time_zone);
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

# Accepts a string which looks like date per the compiled dates.
# Returns a DateTime object representing that date or `undef` if the string cannot be parsed.
sub _parse_formatted_datestring_to_date {
    my ($self, $datestring) = @_;

    my $d = $datestring;
    my $formatted_datestring = $self->_formatted_datestring;
    return unless defined $d && $d =~ qr/^$formatted_datestring$/;

    my %date_attributes = $self->normalize_date_attributes(%+);

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
        try { $maybe_date_object->set_locale($self->datetime_locale) };
        try { $maybe_date_object->set_time_zone($time_zone) };
        if ($maybe_date_object->strftime('%Z') eq 'floating') {
            $maybe_date_object->set_time_zone($self->_time_zone);
        };
    }
    return $maybe_date_object;
}

sub parse_formatted_datestring_to_date {
    my ($self, $date) = @_;
    return $self->_parse_formatted_datestring_to_date($date);
}

#######################################################################
#                       Parsing multiple dates                        #
#######################################################################

# Parse several date strings to dates at once.
sub parse_all_datestrings_to_date {
    my ($self, @dates) = @_;

    my @dates_to_return;
    foreach my $date (@dates) {

        if (my $date_res = $self->_parse_formatted_datestring_to_date($date)) {
            push @dates_to_return, $date_res;
            next;
        }
        my $date_object = $self->_parse_descriptive_datestring_to_date($date)
            or return;
        push @dates_to_return, $date_object;
    }
    return @dates_to_return;
}

sub extract_dates_from_string {
    my ($self, $string) = @_;
    my @dates;
    my $formatted_datestring = $self->_formatted_datestring;
    my $fully_descriptive_regex = $self->_fully_descriptive_regex;
    while ($string =~ /(\b$formatted_datestring\b|$fully_descriptive_regex)/g) {
        my $date = $1;
        $string =~ s/$date//;
        push @dates, $date;
    }
    @dates = $self->parse_all_datestrings_to_date(@dates);
    $_ = $string;
    return @dates;
}

#######################################################################
#                    Relative & Descriptive dates                     #
#######################################################################

has relative_datestring => (
    is      => 'ro',
    default => sub { $RE{date}{relative} },
);

has _descriptive_datestring => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub _build__descriptive_datestring {
    my $self = shift;
    return qr/$RE{date}{descriptive}{-locale=>$self->_locale}{-names}/;
}

has _fully_descriptive_regex => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub _build__fully_descriptive_regex {
    my $self = shift;
    return qr/$RE{date}{descriptive}{full}{-locale=>$self->_locale}{-names}/;
}

has descriptive_datestring => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

# formats parsed by vague datestring, without colouring
# the context of the code using it
sub _build_descriptive_datestring {
    my $self = shift;
    return $RE{date}{descriptive}{-locale=>$self->_locale};
}

sub is_relative_datestring {
    my $datestring = shift;
    return 1 if $datestring =~ $RE{date}{relative};
    return 0;
}

sub is_formatted_datestring {
    my ($self, $datestring) = @_;
    my $formatted_datestring = $self->formatted_datestring;
    return 1 if $datestring =~ /^$formatted_datestring$/;
    return 0;
}

sub _util_add_direction {
    my ($direction, $unit, $amount) = @_;
    $direction = _normalize_direction($direction);
    my $multiplier = _direction_to_multiplier($direction);
    return () if $multiplier == 0;
    # These should eventually be handled by NumberStyle
    $amount =~ s/^(?:a|the)$/1/i;
    my $style = number_style_for($amount);
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
    while ($amount_string =~ /$RE{date}{unit}{amount}{-names}/g) {
        my $amount = $+{num};
        my $unit = $+{unit};
        my ($add_unit, $add_amount) = _util_add_direction($direction, $unit, $amount);
        # Handles weeks as being days, but also allows for multiple
        # occurrences of a single unit type.
        $modifiers{$add_unit} = ($modifiers{$add_unit} // 0) + $add_amount;
    }
    return %modifiers;
}

sub _datetime_now {
    my $self = shift;
    return DateTime->now(
        time_zone => $self->_time_zone,
        locale    => $self->datetime_locale,
    );
}

sub _normalize_direction {
    my $direction = shift or return;
    return 'next' if $direction =~ /(?:next|upcoming|in|from|after)/i;
    return 'last' if $direction =~ /(?:previous|last|ago|before)/i;
    return 'this' if $direction =~ /(?:this|current)/i;
    die "Unknown direction $direction\n";
}

sub _normalize_unit {
    return lc shift;
}

sub _direction_to_multiplier {
    my $direction = shift;
    return 1  if $direction eq 'next';
    return -1 if $direction eq 'last';
    return 0  if $direction eq 'this';
}

sub _with_zero_time {
    my $date = shift;
    $date = $date->clone();
    $date->set_hour(0);
    $date->set_minute(0);
    $date->set_second(0);
    return $date;
}

# Ensure the date has the correct 'start' components for a unit; for
# example, a month should start with the first day; a day with
# midnight, etc.
sub _date_for_unit {
    my ($date, $unit) = @_;
    $date = $date->clone();
    if ($unit eq 'day') {
        $date = _with_zero_time($date);
    } elsif ($unit eq 'month') {
        $date = _with_zero_time($date);
        $date->set_day(1);
    } elsif ($unit eq 'year') {
        $date = _with_zero_time($date);
        $date->set_month(1);
        $date->set_day(1);
    }
    return $date;
}

sub _months_between {
    my ($date1, $date2) = @_;
    return abs (($date1 - $date2)->in_units('months'));
}

sub _parse_descriptive_datestring_to_date {
    my ($self, $string, $base_time) = @_;

    my $fully_descriptive_regex = $self->_fully_descriptive_regex;

    return unless (defined $string && $string =~ qr/^$fully_descriptive_regex$/);
    my $relative_date = $+{r};
    my %date_attributes = $self->normalize_date_attributes(%+);

    $base_time = $self->_datetime_now() unless($base_time);
    my $month = $date_attributes{month}; # Set in each alternative match.

    my $date;
    if ($relative_date) {
        my $tmp_date;
        if (my $rec = $+{rec}) {
            # Relative to some date, so we just treat that date as 'today'.
            $tmp_date = $self->parse_datestring_to_date($rec);
            $relative_date .= 'today';
        } else {
            $tmp_date = $self->_datetime_now();
        }
        # relative dates, tomorrow, yesterday etc
        my @to_add;
        my $unit = '';
        if (my ($day) = $relative_date =~ /^$RE{date}{day}{relative}{-keep}$/) {
            $unit = 'day';
            if (lc $day eq 'tomorrow') {
                @to_add = _util_add_direction('next', $unit, 1);
            } elsif (lc $day eq 'yesterday') {
                @to_add = _util_add_direction('last', $unit, 1);
            }
        } elsif ($relative_date =~ $RE{date}{unit}{directional}{-names}) {
            my $direction = _normalize_direction($+{dir});
            $unit = _normalize_unit($+{unit});
            @to_add = _util_add_direction($direction, $unit, 1);
        } elsif ($relative_date =~ $RE{date}{relative}{directional}{-names}) {
            @to_add = _util_parse_amounts_to_modifiers($+{dir}, $+{amounts});
        }
        $tmp_date = _date_for_unit($tmp_date, $unit);
        $tmp_date->add(@to_add);
        return $tmp_date;
    } elsif (my $day = $date_attributes{day_of_month}) {
        return $self->_parse_formatted_datestring_to_date($base_time->year() . "-$month-$day");
        return $self->parse_datestring_to_date($base_time->year() . "-$month-$day");
    } elsif (my $direction = _normalize_direction($+{direction})) {
        my $tmp_date = $self->parse_datestring_to_date($base_time->year() . "-$month-01");
        # Next: 'Immediately following'
        if ($direction eq 'next') {
            $tmp_date->add(years => 1) if $base_time >= $tmp_date;
        # Last: 'Most recent'
        } elsif ($direction eq 'last') {
            $tmp_date->add(years => -1) if $base_time <= $tmp_date;
        # This: Current or next
        } elsif ($direction eq 'this') {
            my $next = $tmp_date->clone()->add(years => 1);
            unless (abs($next - $base_time) > abs($tmp_date - $base_time)) {
                $tmp_date->add(years => 1) if $base_time > $tmp_date;
            }
        }
        return $tmp_date;
    } elsif (my $year = $date_attributes{year}) {
        # Month and year is the first of that month.
        return $self->parse_datestring_to_date("$year-$month-01");
    } else {
        my $tmp_date = $self->parse_datestring_to_date($base_time->year() . "-$month-01");
        return $tmp_date if $tmp_date->month eq $base_time->month;
        # single named months
        # "january" in january means the current month
        # otherwise it means the closest january; same as 'this'
        my $next = $tmp_date->clone()->add(years => 1);
        my $last = $tmp_date->clone()->add(years => -1);
        if ($self->direction_preference eq 'prefer_past') {
            return $last if $base_time->month < $tmp_date->month;
            return $tmp_date;
        } elsif ($self->direction_preference eq 'prefer_future') {
            return $next if $base_time->month > $tmp_date->month;
            return $tmp_date;
        }
        return $last
            if _months_between($base_time, $last) < _months_between($tmp_date, $base_time);
        return $next
            if _months_between($base_time, $next) <= _months_between($tmp_date, $base_time);
        return $tmp_date;
    }
}

# Takes a DateTime object (or a string which can be parsed into one)
# and returns a standard formatted output string or an empty string if it cannot be parsed.
sub format_date_for_display {
    my ($self, $dt, $use_clock) = @_;

    my $ddg_format = "%d %b %Y";    # Just here to make it easy to see.
    my $ddg_clock_format = "%d %b %Y %T %Z"; # 01 Jan 2012 00:00:00 UTC (HTTP without day)
    my $date_format = $use_clock ? $ddg_clock_format : $ddg_format;
    my $string     = '';            # By default we've got nothing.
    # They didn't give us a DateTime object, let's try to make one from whatever we got.
    $dt = $self->parse_datestring_to_date($dt) if (ref($dt) !~ /DateTime/);
    $string = $dt->strftime($date_format) if ($dt);

    return $string;
}

#######################################################################
#                                Stash                                #
#######################################################################

sub _get_loc {
    _fetch_stash('$loc');
}

sub _get_lang {
    return _fetch_stash('$lang');
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

1;
