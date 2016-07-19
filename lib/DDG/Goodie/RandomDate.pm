package DDG::Goodie::RandomDate;
# ABSTRACT: Generate random dates from given formats.

use DDG::Goodie;
use strict;

use DateTime;
use DateTime::Locale;   # Need it here to force Travis to build
                        # the dependency.
use List::Util qw(first);

zci answer_type => 'random_date';

zci is_cached => 0;

triggers start => 'random';
triggers any   => 'date';

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

my @blacklist = (
    '\\%{[^}]*}', # Access to any DateTime method.
);

my $blacklist_re = join '|', map { "($_)" } @blacklist;

my $standard_re = join '|', map { "($_)" } (keys %standard_queries);

handle query => sub {
    my $query = shift;
    my $format;
    my $type = 'format';
    my $force_cldr = 0;
    # TODO: Allow blacklisted elements, but escape them for formatting.
    return if $query =~ /$blacklist_re/;
    if ($query =~ /^random ($standard_re)$/i) {
        my $standard_query = $1;
        my $k = first { $standard_query =~ qr/^$_$/i } (keys %standard_queries);
        ($format, $type) = @{$standard_queries{$k}};
    } else {
        return unless $query =~ /^((random|example) )?date for (?<format>.+?)(?<cldr> \(cldr\))?$/i;
        $format = $+{'format'};
        $force_cldr = defined $+{cldr};
    }
    srand();
    my $random_date = get_random_date($lang->locale);
    my $formatted = format_date($format, $random_date, $force_cldr) or return;

    return if $formatted eq $format;

    my $subtitle = build_subtitle(
        type   => $type,
        format => $format,
    );

    return html_enc("$formatted"),
        structured_answer => {

            data => {
              title    => html_enc("$formatted"),
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
    $type eq 'format'
        ? "Random date for: " . html_enc($format)
        : "Random $type";
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
my $MAX_RAND = $MAX_DATE - $MIN_DATE;
sub get_random_date {
    my $locale = shift;
    my $rand_num = int(rand($MAX_RAND));
    return DateTime->from_epoch(
        epoch => ($rand_num + $MIN_DATE), locale => $locale
    );
}

1;
