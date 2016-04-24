package DDG::Goodie::TimezoneConverter;
# ABSTRACT: Convert times between timezones.

use 5.010;
use strict;
use warnings;
use DDG::Goodie;
use DDG::GoodieRole::Dates;

use DateTime;
use POSIX qw(fmod);

my %timezones = DDG::GoodieRole::Dates::get_timezones();

triggers any => lc for keys %timezones;

zci is_cached   => 1;
zci answer_type => 'timezone_converter';

my $default_tz   = 'UTC';
my $localtime_re = qr/(?:(?:my|local|my local)\s*time(?:zone)?)/i;
my $timezone_re  = qr/(?:\w+(?:\s*[+-]0*[0-9]{1,5}(?::[0-5][0-9])?)?|$localtime_re)?/;

sub parse_timezone {
    my $timezone = shift;
    
    # They said "my timezone" or nothing at all.
    if (!defined($timezone) || !$timezone || $timezone =~ /$localtime_re/i) {
        my $dt = DateTime->now(time_zone => $loc->time_zone || $default_tz );
        return ($dt->time_zone_short_name, $dt->offset / 3600);
    }

    # Normalize
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
          (?<american>(?:(?<am>A)|(?<pm>P))\.?M\.?)?
        # Spaces between tokens
        \s* \b
        # Optional "from" indicator for input timezone
        (?:\s+FROM\s+)?
        # Optional input timezone
        (?<from_tz>$timezone_re)
        # Spaces
        (?:\s+
        # in keywords
        (?: IN (?: TO )? | TO )
        # Spaces
        \s+
        # Output timezone
        (?<to_tz>$timezone_re))?
        \s* \z
    }ix or return;

    my ($hours, $minutes, $seconds) = map { $_ // 0 } ($+{'h'}, $+{'m'}, $+{'s'});
    my $american        = $+{'american'};
    my $pm              = ($+{'pm'} && $hours != 12) ? 12 : ($+{'am'} && $hours == 12) ? -12 : 0;

    my $input = {};
    my $output = {};
    # parse_timezone returns undef if the timezone cannot be parsed
    ($input->{timezone}, $input->{gmt_timezone}) = parse_timezone($+{'from_tz'});
    return unless defined $input->{gmt_timezone};
    ($output->{timezone}, $output->{gmt_timezone}) = parse_timezone($+{'to_tz'});
    return unless defined $output->{gmt_timezone};

    my $modifier = $output->{gmt_timezone} - $input->{gmt_timezone};

    for ( $input->{gmt_timezone}, $output->{gmt_timezone} ) {
        $_ = to_time $_;
        s/\A\b/+/;
        s/:00\z//;
    }

    $input->{time}  = $hours + $minutes / 60 + $seconds / 3600 + $pm;
    $output->{time} = $input->{time} + $modifier;
    for my $io ( $input, $output ) {
        my $time = $io->{time};
        $io->{days} = '';
        if ( $time < 0 ) {
            my $s = $time <= -24 ? 's' : "";
            $io->{days} = sprintf ' (%i day%s prior)', $time / -24 + 1, $s;

            # fmod() doesn't do what I want, Perl's % operator doesn't
            # support floating point numbers. Instead, I will use
            # lamest hack ever to do things correctly.
            $time += int( $time / -24 + 1 ) * 24;
        }
        elsif ( $time >= 24 ) {
            my $s = $time >= 48 ? 's' : "";
            $io->{days} = sprintf ' (%i day%s after)', $time / 24, $s;
        }
        $time = fmod $time, 24;
        $io->{time} = to_time($time, $american);

        $io->{format} = '%s (UTC%s)';
        $io->{timezones}  = [ $io->{timezone},  $io->{gmt_timezone} ];

        $io->{timezone} =~ /(\A\w+)/;
        if ( $timezones{ $1 } !~ /[1-9]/ ) {
            $io->{format} = '%s';
            pop @{$io->{timezones}};
        }
    }

    my $input_string = sprintf "%s $input->{format} to $output->{format}",
            ucfirst $input->{time}, @{$input->{timezones}}, @{$output->{timezones}};

    my $output_string = sprintf "%s %s%s",
            ucfirst $output->{time}, $output->{timezone}, $output->{days};

    return $output_string, structured_answer => {
        input     => [html_enc($input_string)],
        operation => 'Convert Timezone',
        result    => html_enc($output_string),
    };
};

1;
