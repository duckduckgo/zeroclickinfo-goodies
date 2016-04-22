package DDG::GoodieRole::Dates::Parser;
# ABSTRACT: A role to allow Goodies to recognize and work with dates in different notations.

use strict;
use warnings;

use Moo;
use DateTime;
use File::Find::Rule;
use List::MoreUtils qw( uniq first_index );
use List::Util qw( first );
use Module::Data;
use Package::Stash;
use Devel::StackTrace;
use Path::Class;
use Try::Tiny;
use YAML::XS qw(LoadFile);
use DateTime::Locale;
use DateTime::Format::Natural;

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

sub _build_datetime_locale {
    my $self = shift;
    my $date_locale = DateTime::Locale->load($self->_locale);
}

sub _build__locale {
    my $self = shift;
    defined $self->lang ? $self->lang->locale : 'en';
}

sub _build__time_zone {
    my $self = shift;
    return defined $self->loc ? $self->loc->time_zone : 'UTC';
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

has '_date_format' => (
    is => 'ro',
    lazy => 1,
    builder => 1,
);

# TODO: Don't use this, but instead build up more date formats from
# the locale information.
sub _build__date_format {
    my $self = shift;
    my $short_format = $self->datetime_locale->date_format_short;
    $short_format =~ s/\W//g;
    return uc join '', uniq (split '', $short_format);
}

has _ordered_date_formats => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

my @standard_formats = map { @{$_->{formats}} } (values %time_formats);

sub _build__ordered_date_formats {
    my $self = shift;
    my $l = $self->datetime_locale;
    my @additional_formats = (
        $l->glibc_date_format,
        $l->glibc_date_1_format,
        $l->glibc_datetime_format,
    );
    my @ordered_formats = sort { length $b <=> length $a } (
        @standard_formats, @additional_formats,
    );
    return \@ordered_formats;
}

my $days_months = LoadFile(_dates_dir('days_months.yaml'));

my %months = %{$days_months->{months}};
my %weekdays = %{$days_months->{weekdays}};
my %short_month_to_number = map { lc $_->{short} => $_->{numeric} } (values %months);
my @short_days = map { $_->{short} } (values %weekdays);

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

my $tz_yaml = LoadFile(_dates_dir('time_zones.yaml'));
my %tz_offsets = %{$tz_yaml};

sub get_timezones {
    return %tz_offsets;
}
# Timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations

# %H
my $hour = qr/(?<hour>[01][0-9]|2[0-3])/;
# %M
my $minute = qr/(?<minute>[0-5][0-9])/;
# %S
my $second = qr/(?<second>[0-5][0-9]|60)/;
# %T
my $time = '%H:%M:%S';
# %r
my $time_12h = '%I:%M:%S%p';
# I
my $hour_12 = qr/(?<hour>0[1-9]|1[0-2])/;
# %Y
my $year = qr/(?<year>[0-9]{4})/;
# %d
my $day_of_month = qr/(?<day_of_month>0[1-9]|[12][0-9]|3[01])/;
# %e
my $day_of_month_space_padded = qr/(?<day_of_month> [1-9]|[12][0-9]|3[01])/;
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
# %c
my $date_default = '%a %b  %%d %T %Y';

has _percent_to_regex => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub _build__percent_to_regex {
    my $self = shift;
    my $l = $self->datetime_locale;
    # %a
    my @abbreviated_weekdays = @{$l->day_format_abbreviated};
    my $abbreviated_weekday = qr/(?:@{[join '|', @abbreviated_weekdays]})/i;
    # %A
    my @full_days = @{$l->day_format_wide};
    my $full_weekday    = qr/(?:@{[join '|', @full_days]})/i;
    # %b
    my @short_months = (@{$l->month_format_abbreviated}, @{$l->month_stand_alone_abbreviated});
    my $abbreviated_month = qr/(?<month>@{[join '|', @short_months]})/i;
    # %p
    my @am_pm = @{$l->am_pm_abbreviated};
    my $am_pm = qr/(?<am_pm>@{[join '|', @am_pm]})/i;
    # %B
    my @full_months = (@{$l->month_format_wide}, @{$l->month_stand_alone_wide});
    my $month_full = qr/(?<month>@{[join '|', @full_months]})/i;
    return {
        '%A' => $full_weekday,
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
        '%e' => $day_of_month_space_padded,
        '%m' => $month,
        '%p' => $am_pm,
        '%r' => $time_12h,
        '%y' => $year_last_two_digits,
        '%z' => $hhmm_numeric_time_zone,
        '%%D' => $day_of_month_natural,
        '%%d' => $day_of_month_allow_single,
        '%%m' => $month_allow_single,
    };
}

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
    my ($self, $format) = @_;
    return $self->format_spec_to_regex($format, 1);
}

sub format_spec_to_regex {
    my ($self, $spec, $no_captures, $no_escape) = @_;
    unless ($no_escape) {
        $spec = quotemeta($spec);
        $spec =~ s/\\( |%|-)/$1/g;
    }
    while ($spec =~ /(%(?:%\w|\w))/g) {
        my $sequence = $1;
        if (my $regex = $self->_percent_to_regex->{$sequence}) {
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

#######################################################################
#                       Formatted Date Strings                        #
#######################################################################

has _format_to_regex => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub _build__format_to_regex {
    my $self = shift;
    my %format_to_regex = map {
        my $format = $_;
        my $re = $self->format_spec_to_regex($format);
        die "No regex produced from format $format" unless $re;
        $format => $re;
    } @{$self->_ordered_date_formats};
    return \%format_to_regex;
}

has _formatted_datestring => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

# Called once to build $formatted_datestring
sub _build__formatted_datestring {
    my $self = shift;
    my @regexes = ();

    foreach my $spec (@{$self->_ordered_date_formats}) {
        my $re = $self->format_spec_to_regex($spec, 0);
        die "No regex produced from spec: $spec" unless $re;
        if (first { $_ eq $re } @regexes) {
            die "Regex redefined for spec: $spec";
        }
        push @regexes, $re;
    }

    my $returned_regex = join '|', @regexes;
    return qr/(?:$returned_regex)/i;
}

sub _build_formatted_datestring {
    my $self = shift;
    return neuter_regex($self->_formatted_datestring);
}

has formatted_datestring => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

# Parses any string that *can* be parsed to a date object
sub parse_datestring_to_date {
    my ($self, $date_string, $base) = @_;
    my $standard_result = $self->_parse_formatted_datestring_to_date($date_string);
    return $standard_result if defined $standard_result;
    return $self->_parse_descriptive_datestring_to_date($date_string, $base);
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
    return $year_raw if $year_raw =~ qr/^$year$/;
    return '19' . $year_raw if $year_raw =~ qr/^$year_last_two_digits$/;
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

sub _get_date_match {
    my ($re, $date) = @_;
    return %+ if $date =~ qr/^$re$/;
    return;
}

# Accepts a string which looks like date per the compiled dates.
# Returns a DateTime object representing that date or `undef` if the string cannot be parsed.
sub _parse_formatted_datestring_to_date {
    my ($self, $datestring) = @_;

    my $d = $datestring;
    my $formatted_datestring = $self->_formatted_datestring;
    return unless defined $d && $d =~ qr/^$formatted_datestring$/;

    my %date_attributes;

    foreach my $format (@{$self->_ordered_date_formats}) {
        my $re = $self->_format_to_regex->{$format};
        if (my %match_result = _get_date_match($re, $datestring)) {
            %date_attributes = $self->normalize_date_attributes(%match_result);
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
        my $date_object = $self->_parse_descriptive_datestring_to_date($date);

        return unless $date_object;
        push @dates_to_return, $date_object;
    }
    return @dates_to_return;
}

sub _retrieve_datestrings {
    my ($self, $string) = @_;
    return unless $string;
    my $formatted_datestring = $self->formatted_datestring();
    if ($string =~ /^(.+?)?($formatted_datestring)(.+?)?$/) {
        my $start = $1;
        my $formatted = $2;
        my $end = $3;
        return grep { $_ } ($self->_retrieve_datestrings($start), $formatted,
                $self->_retrieve_datestrings($end));
    } else {
        my $parser = $self->_date_desc_parser;
        my @dates = $parser->extract_datetime($string);
        return @dates;
    }
}

sub extract_dates_from_string {
    my ($self, $string) = @_;
    my @dates = $self->_retrieve_datestrings($string);
    return $self->parse_all_datestrings_to_date(@dates);
}

#######################################################################
#                    Relative & Descriptive dates                     #
#######################################################################

sub neuter_regex {
    my $re = shift;
    $re =~ s/\?<\w+>/?:/g;
    return qr/$re/;
}

sub is_formatted_datestring {
    my ($self, $datestring) = @_;
    my $formatted_datestring = $self->formatted_datestring;
    return 1 if $datestring =~ /^$formatted_datestring$/;
    return 0;
}

sub _datetime_now {
    my $self = shift;
    return DateTime->now(
        time_zone => $self->_time_zone,
        locale    => $self->datetime_locale,
    );
}

sub _normalize_date_attributes {
    my ($self, $date) = @_;
    my $now = $self->_datetime_now();
    $date = $date->clone();
    $date->set_time_zone($now->time_zone);
    $date->set_locale($now->locale);
    return $date;
}

# If there's something that should be parsable, and can be represented
# in a DateTime::Format::Normalize format, stick it here.
my %descriptive_exceptions = (
    'from today'   => 'from now',
    'before today' => 'before now',
    'current'      => 'this',
    'a'            => '1',
    '(?<type>week|month|year)s time' => '$+{type}',
);

sub _normalize_descriptive_string {
    my $description = shift;
    while (my ($match, $replacement) = each %descriptive_exceptions) {
        while ($description =~ /\b$match\b/g) {
            my %matches = %+;
            # We can't just do s/$match/$replacement :(
            # If you figure this out, you are welcome to update it!
            my $tmp_replacement = $replacement =~
                s/(?:\$\+\{(\w+)\})/$matches{$1}/gr;
            $description =~ s/\b$match\b/$tmp_replacement/g;
        }
    }
    return $description;
}

has _date_desc_parser => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub _build__date_desc_parser {
    my $self = shift;
    return DateTime::Format::Natural->new(
        time_zone => $self->_datetime_now->time_zone,
    );
}

sub _parse_descriptive_datestring_to_date {
    my ($self, $string) = @_;
    # Prevent fully ambiguous formats like 01/01/2000 from getting
    # through.
    return unless $string =~ /[[:alpha:]]/;
    $string = _normalize_descriptive_string("$string");
    my $parser = $self->_date_desc_parser;
    my $res = $parser->parse_datetime($string);
    return $self->_normalize_date_attributes($res)
        if $parser->success();
    return;
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
