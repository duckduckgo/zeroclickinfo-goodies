package DDG::Goodie::TimezoneConverter;
# ABSTRACT: Convert times between timezones.

use 5.010;
use strict;
use warnings;
use DDG::Goodie;
use DDG::GoodieRole::Dates;

use DateTime;
use POSIX qw(fmod);

attribution github => ['GlitchMr', 'GlitchMr'],
            github => ['https://github.com/samph',   'samph'],
            github => 'cwallen';


primary_example_queries '10:00AM MST to PST';
secondary_example_queries '19:00 UTC to EST', '1am UTC to PST';
description 'convert times between timezones';
name 'Timezone Converter';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/TimezoneConverter.pm';
category 'calculations';
topics 'travel';

triggers any => qw(in into to);

zci is_cached   => 1;
zci answer_type => 'timezone_converter';

my %timezones = DDG::GoodieRole::Dates::get_timezones();

my $default_tz   = 'UTC';
my $localtime_re = qr/(?:(?:my|local|my local)\s*time(?:zone)?)/i;
my $timezone_re  = qr/(?:\w+(?:\s*[+-]0*[0-9]{1,5}(?::[0-5][0-9])?)?|$localtime_re)?/;

sub parse_timezone {
    my $timezone = shift;

    # They said "my timezone" or similar.
    if ($timezone =~ /$localtime_re/i) {
        my $dt = DateTime->now(time_zone => $loc->time_zone || $default_tz );
        return ($dt->time_zone_short_name, $dt->offset / 3600);
    }

    # Normalize
    $timezone ||= $default_tz;
    $timezone = uc $timezone;
    $timezone =~ s/\s+//g;

    my ($name, $modifier, $minutes) = $timezone =~ /\A(\w+)(?:([+-]\d+)(?::(\d\d))?)?\z/;

    # If timezone doesn't exist, skip it
    return unless defined $timezones{$name};

    # Modifier can be skipped
    $modifier //= 0;

    # Minutes can be skipped too
    $minutes //= 0;

    my $hour = int( $timezones{$name} / 100 );
    $minutes += $timezones{$name} % 100;

    return ($timezone, $hour + $modifier + $minutes / 60);
}

sub to_time {
    my ($hours, $american) = @_;

    my $pm = "";
    my $seconds = 3600 * fmod $hours, 1 / 60;

    # I'm using floating point numbers. They sometimes don't do what I want.
    if ( sprintf( '%.5f', $seconds ) == 60 ) {
        $seconds = 0;
    }
    my $minutes
        = ( $hours - int $hours ) * 60 - sprintf( '%.4f', $seconds ) / 60;
    my $seconds_format = int $seconds ? ':%02.0f' : "";
    if ($american) {
        # Special case certain hours
        return 'midnight' if $hours == 0;
        return 'noon'     if $hours == 12;
        $pm = ' AM';
        if ($hours > 12) {
            $pm = ' PM';
            $hours -= 12 if (int($hours) > 12);
        }
    }
    sprintf "%i:%02.0f$seconds_format$pm", $hours, $minutes, $seconds;
}

handle query => sub {
    my $query = $_;
    $query =~ m{
        \A \s*
        # Time
          # Hours
          (?<h>[01]?[0-9] | 2[0-3])
          (?:
          #Optional colon
          :?
            # Minutes
            (?<m>[0-5] [0-9])
            (?:
              # Seconds
              :(?<s>[0-5] [0-9])
            )?
          )?
          # Optional spaces between tokens
          \s*
          # AM/PM
          (?<american>(?:A|(?<pm>P))\.?M\.?)?
        # Spaces between tokens
        \s* \b
        # Optional "from" indicator for input timezone
        (?:\s+FROM\s+)?
        # Optional input timezone
        (?<from_tz>$timezone_re)
        # Spaces
        \s+
        # in keywords
        (?: IN (?: TO )? | TO )
        # Spaces
        \s+
        # Output timezone
        (?<to_tz>$timezone_re)
        \s* \z
    }ix or return;

    my ($hours, $minutes, $seconds) = map { $_ // 0 } ($+{'h'}, $+{'m'}, $+{'s'});
    my $american        = $+{'american'};
    my $pm              = ($+{'pm'} && $hours != 12) ? 12 : (!$+{'pm'} && $hours == 12) ? -12 : 0;

    # parse_timezone returns undef if the timezone cannot be parsed
    my ($input_timezone, $gmt_input_timezone) = parse_timezone($+{'from_tz'});
    return unless defined $gmt_input_timezone;
    my ($output_timezone, $gmt_output_timezone) = parse_timezone($+{'to_tz'});
    return unless defined($gmt_output_timezone);

    my $modifier = $gmt_output_timezone - $gmt_input_timezone;

    for ( $gmt_input_timezone, $gmt_output_timezone ) {
        $_ = to_time $_;
        s/\A\b/+/;
        s/:00\z//;
    }

    my $input_time  = $hours + $minutes / 60 + $seconds / 3600 + $pm;
    my $output_time = $input_time + $modifier;
    for ( $input_time, $output_time ) {
        my $days = "";
        if ( $_ < 0 ) {
            my $s = $_ <= -24 ? 's' : "";
            $days = sprintf ', %i day%s prior', $_ / -24 + 1, $s;

            # fmod() doesn't do what I want, Perl's % operator doesn't
            # support floating point numbers. Instead, I will use
            # lamest hack ever to do things correctly.
            $_ += int( $_ / -24 + 1 ) * 24;
        }
        elsif ( $_ >= 24 ) {
            my $s = $_ >= 48 ? 's' : "";
            $days = sprintf ', %i day%s after', $_ / 24, $s;
        }
        $_ = fmod $_, 24;
        $_ = to_time($_, $american) . $days;
    }

    my ( $input_format, $output_format ) = ('%s, UTC%s') x 2;
    my @input_timezones  = ( $input_timezone,  $gmt_input_timezone );
    my @output_timezones = ( $output_timezone, $gmt_output_timezone );

    # I'm using @timezones because I need list context.
    if ( @timezones{ $input_timezone =~ /(\A\w+)/ } !~ /[1-9]/ ) {
        $input_format = '%s';
        pop @input_timezones;
    }
    if ( @timezones{ $output_timezone =~ /(\A\w+)/ } !~ /[1-9]/ ) {
        $output_format = '%s';
        pop @output_timezones;
    }

    my $output_string = sprintf "%s ($input_format) is %s ($output_format).",
            ucfirst $input_time, @input_timezones,
            $output_time, @output_timezones;
    my $output_html = sprintf "<div class='zci--timezone-converter text--secondary'><span class='text--primary'>%s</span> ($input_format) is <span class='text--primary'>%s</span> ($output_format).</div>",
            ucfirst $input_time, @input_timezones,
            $output_time, @output_timezones;

    return $output_string, html => $output_html;
};

1;
