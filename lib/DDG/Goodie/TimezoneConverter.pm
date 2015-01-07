package DDG::Goodie::TimezoneConverter;
# ABSTRACT: Convert times between timezones.

use 5.010;
use strict;
use warnings;
use DDG::Goodie;

use DateTime;
use POSIX qw(fmod);

attribution github => ['GlitchMr', 'GlitchMr'];

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

my %timezones = qw(
    ACDT   10.5 ACST    9.5 ACT       8 ADT      -3 AEDT     11 AEST     10
    AFT     4.5 AKDT     -8 AKST     -9 AMST      5 AMT       4 ART      -3
    AST      -4 AWDT      9 AWST      8 AZOST    -1 AZT       4 BDT       8
    BIOT      6 BIT     -12 BOT      -4 BRT      -3 BST       1 BTT       6
    CAT       2 CCT     6.5 CDT      -5 CEDT      2 CEST      2 CET       1
    CHADT 13.75 CHAST 12.75 CHOT     -8 CHST     10 CHUT     10 CIST     -8
    CIT       8 CKT     -10 CLST     -3 CLT      -4 COST     -4 COT      -5
    CST      -6 CT        8 CVT      -1 CWST   8.75 CXT       7 DAVT      7
    DDUT      7 DFT       1 EASST    -5 EAST     -6 EAT       3 ECT      -5
    EDT      -4 EEDT      3 EEST      3 EET       2 EGST      0 EGT      -1
    EIT       9 EST      -5 FET       3 FJT      12 FKST     -3 FKT      -4
    FNT      -2 GALT     -6 GAMT     -9 GET       4 GFT      -3 GILT     12
    GIT      -9 GMT       0 GST       4 GYT      -4 HADT     -9 HAEC      2
    HAST    -10 HKT       8 HMT       5 HOVT      7 HST     -10 ICT       7
    IDT       3 IOT       3 IRDT      8 IRKT      8 IRST    3.5 IST     5.5
    JST       9 KGT       7 KOST     11 KRAT      7 KST       9 LHST     11
    LINT     14 MAGT     12 MART   -9.5 MAWT      5 MDT      -6 MEST      2
    MET       1 MHT      12 MIST     11 MIT    -9.5 MMT     6.5 MSK       4
    MST      -7 MUT       4 MVT       5 MYT       8 NCT      11 NDT    -2.5
    NFT    11.5 NPT    5.75 NST    -3.5 NT     -3.5 NUT   -11.5 NZDT     13
    NZST     12 OMST      6 ORAT     -5 PDT      -7 PET      -5 PETT     12
    PGT      10 PHOT     13 PHT       8 PKT       5 PMDT      8 PMST      8
    PONT     11 PST      -8 RET       4 ROTT     -3 SAKT     11 SAMT      4
    SAST      2 SBT      11 SCT       4 SGT       8 SLT     5.5 SRT      -3
    SST     -11 SYOT      3 TAHT    -10 TFT       5 THA       7 TJT       5
    TKT      14 TLT       9 TMT       5 TOT      13 TVT      12 UCT       0
    ULAT      8 UTC       0 UYST     -2 UYT      -3 UZT       5 VET    -4.5
    VLAT     10 VOLT      4 VOST      6 VUT      11 WAKT     12 WAST      2
    WAT       1 WEDT      1 WEST      1 WET       0 WST       8 YAKT      9
    YEKT      5
);

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

    return ($timezone, $timezones{$name} + $modifier + $minutes / 60);
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
            # Minutes
            :(?<m>[0-5] [0-9])
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
    if ( !@timezones{ $input_timezone =~ /(\A\w+)/ } ) {
        $input_format = '%s';
        pop @input_timezones;
    }
    if ( !@timezones{ $output_timezone =~ /(\A\w+)/ } ) {
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
