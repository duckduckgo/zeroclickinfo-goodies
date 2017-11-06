package DDG::Goodie::RandomDate;
# ABSTRACT: Generate random dates from given formats.

use DDG::Goodie;
use strict;

use DateTime;
use DateTime::Locale;   # Need it here to force Travis to build
                        # the dependency.
use List::Util qw(first);
with 'DDG::GoodieRole::Dates';

zci answer_type => 'random_date';

zci is_cached => 0;

triggers start => 'random';
triggers any   => 'date';

# TODO: Replace these with $RE{...} when #2810 is merged.
my $date_re = datestring_regex();

my %standard_queries = (
    '(week ?)?day'           => ['%A', 'Weekday'],
    'month( of the year)?'   => ['%B', 'Month'],
    'date ?time'             => ['%c', 'Date and Time'],
    'century'                => ['%C', 'Century'],
    'day of( the)? month'    => ['%d', 'Day of the Month'],
    'iso[- ]?8601 date'      => ['%F', 'ISO-8601 Date'],
    'hour'                   => ['%H', 'Hour'],
    'day of( the)? year'     => ['%j', 'Day of the Year'],
    'minute'                 => ['%M', 'Minute'],
    '12[- ]?hour time'       => ['%r', '12-hour Time'],
    'second'                 => ['%S', 'Second'],
    '24[- ]?hour time'       => ['%T', '24-hour Time'],
    'day of( the)? week'     => ['%u', 'Day of the Week'],
    'week( of( the)? year)?' => ['%W', 'Week'],
    'date'                   => ['%x', 'Date'],
    'time'                   => ['%X', 'Time'],
    'year'                   => ['%Y', 'Year'],
);

# TODO: Add support for other types after #2810 is merged.
my %supports_range = map { $_ => $date_re } (
    'Date', 'Date and Time',
);

my @standard_query_forms = keys %standard_queries;

my @blacklist = (
    '\\%\\{[^}]*\\}', # Access to any DateTime method.
);

my $blacklist_re = join '|', map { "($_)" } @blacklist;

my $standard_re = join '|', map { "($_)" } (keys %standard_queries);

my $range_form = qr/ ?((in the )?(past|future)|between.+)/;

handle query => sub {
    my $query = shift;
    $query =~ s/\s*past(.+)/$1 past/i;
    $query =~ s/\s*future(.+)/$1 future/i;
    my $format;
    my $range_type = 'none';
    my $type = 'format';
    my $force_cldr = 0;
    my $range_text = '';
    # TODO: Allow blacklisted elements, but escape them for formatting.
    return if $query =~ /$blacklist_re/;
    if ($query =~ /^random ($standard_re)(?<rt>$range_form)?$/i) {
        $range_text = $+{rt} // '';
        my $standard_query = $1;
        my $k = first { $standard_query =~ qr/^$_$/i } @standard_query_forms;
        ($format, $type) = @{$standard_queries{$k}};
        $range_type = $supports_range{$type} // 'none';
    } else {
        return unless $query =~ /^((random|example) )?date for (?<format>.+?)(?<cldr> \(cldr\))?$/i;
        $format = $+{'format'};
        $force_cldr = defined $+{cldr};
    }
    srand();
    return if $range_text && $range_type eq 'none';
    my ($min_date, $max_date) = parse_range($range_type, $lang->locale, $range_text);
    return if $range_text && !(defined $min_date && defined $max_date);
    my $random_date = get_random_date(
        $lang->locale, $min_date, $max_date
    ) or return;
    my ($formatted, $min_date_formatted, $max_date_formatted) = map {
        format_date($format, $_, $force_cldr);
    } ($random_date, $min_date, $max_date);
    return unless $formatted;

    return if $formatted eq $format;

    my $subtitle = build_subtitle(
        type   => $type,
        format => $format,
        min    => $min_date_formatted,
        max    => $max_date_formatted,
    );

    return $formatted,
        structured_answer => {

            data => {
              title    => $formatted,
              subtitle => $subtitle,
            },

            templates => {
                group => "text",
            }
        };
};

sub build_subtitle {
    my %options = @_;
    my $type    = $options{type};
    my $format  = $options{format};
    my ($min, $max) = @options{qw(min max)};
    my $range_text = $supports_range{$type}
        ? " between $min and $max"
        : '';
    $type eq 'format'
        ? "Random date for: $format"
        : "Random $type$range_text";
}

sub format_date {
    my ($format, $date, $force_cldr) = @_;
    my $formatted;
    if ($format =~ /%/ && !$force_cldr) {
        $formatted = $date->strftime($format);
    } else {
        $formatted = $date->format_cldr($format);
    }
    return if $formatted eq $format;
    return $formatted;
}

# 9999-12-31T23:59:59Z
my $MAX_DATE = 253_402_300_799;
# 0000-01-01T00:00:00Z
my $MIN_DATE = -62_167_219_200;
sub get_random_date {
    my ($locale, $min_date, $max_date) = @_;
    my $range = abs($max_date->epoch - $min_date->epoch);
    return if $range == 0;
    my $rand_num = int(rand($range));
    my $rand_epoch = $min_date->epoch + $rand_num;
    return DateTime->from_epoch(
        epoch => $rand_epoch, locale => $locale
    );
}

sub now {
    my $locale = shift;
    DateTime->now(locale => $locale);
}

sub from_epoch {
    my ($epoch, $locale) = @_;
    return DateTime->from_epoch(
        epoch  => $epoch,
        locale => $locale,
    );
}

sub parse_range {
    my ($range_type, $locale, $range_text) = @_;
    my $start = from_epoch($MIN_DATE, $locale);
    my $end = from_epoch($MAX_DATE, $locale);
    return ($start, $end) if $range_type eq 'none' || $range_text eq '';
    if ($range_text =~ s/(in the )?(?<t>past|future)//i) {
        lc $+{t} eq 'past' and $end = now($locale);
        lc $+{t} eq 'future' and $start = now($locale);
    } elsif (my ($start_text, $end_text) = $range_text
            =~ /between (.+) and (.+)/) {
        $start = parse_datestring_to_date($start_text) or return;
        $end   = parse_datestring_to_date($end_text) or return;
        $start->set_locale($locale);
        $end->set_locale($locale);
    } else {
        return;
    }
    return ($start, $end);
}

1;
