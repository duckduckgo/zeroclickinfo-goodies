package DDG::GoodieRole::Dates;
# ABSTRACT: A role to allow Goodies to recognize and work with dates in different notations.

use strict;
use warnings;

use Moo::Role;

use DateTime;
use List::Util qw( first );
use Try::Tiny;

# This appears to parse most/all of the big ones, however it doesn't present a regex
use DateTime::Format::HTTP;

my %short_month_to_number = (
    jan => 1,
    feb => 2,
    mar => 3,
    apr => 4,
    may => 5,
    jun => 6,
    jul => 7,
    aug => 8,
    sep => 9,
    oct => 10,
    nov => 11,
    dec => 12,
);

# Reused lists and components for below
my $short_day_of_week   = qr#Mon|Tue|Wed|Thu|Fri|Sat|Sun#i;
my $full_day_of_week   = qr#Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday#i;
my %full_month_to_short = map { lc $_ => substr($_, 0, 3) } qw(January February March April May June July August September October November December);
my %short_month_fix     = map { lc $_ => $_ } (values %full_month_to_short);
my $short_month         = qr#Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec#i;
my $full_month          = qr#January|February|March|April|May|June|July|August|September|October|November|December#i;
my $month_regex         = qr#$full_month|$short_month#;
my $time_24h            = qr#(?:(?:[0-1][0-9])|(?:2[0-3]))[:]?[0-5][0-9][:]?[0-5][0-9]#i;
my $time_12h            = qr#(?:(?:0[1-9])|(?:1[012])):[0-5][0-9]:[0-5][0-9]\s?(?:am|pm)#i;
my $date_number         = qr#[0-3]?[0-9]#;
# Covering the ambiguous formats, like:
# DMY: 27/11/2014 with a variety of delimiters
# MDY: 11/27/2014 -- fundamentally non-sensical date format, for americans
my $date_delim              = qr#[\.\\/\,_-]#;
my $ambiguous_dates         = qr#(?:$date_number)$date_delim(?:$date_number)$date_delim(?:[0-9]{4})#i;
my $ambiguous_dates_matches = qr#^(?<m>$date_number)$date_delim(?<d>$date_number)$date_delim(?<y>[0-9]{4})$#i;

# like: 1st 2nd 3rd 4-20,24-30th 21st 22nd 23rd 31st
my $number_suffixes = qr#(?:st|nd|rd|th)#i;

# Timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations
my %tz_offsets = (
    ACDT  => '+1030',
    ACST  => '+0930',
    ACT   => '+0800',
    ADT   => '-0300',
    AEDT  => '+1100',
    AEST  => '+1000',
    AFT   => '+0430',
    AKDT  => '-0800',
    AKST  => '-0900',
    AMST  => '-0300',
    AMT   => '-0400',
    ART   => '-0300',
    AST   => '+0300',
    AWDT  => '+0900',
    AWST  => '+0800',
    AZOST => '-0100',
    AZT   => '+0400',
    BDT   => '+0800',
    BIOT  => '+0600',
    BIT   => '-1200',
    BOT   => '-0400',
    BRT   => '-0300',
    BST   => '+0100',
    BTT   => '+0600',
    CAT   => '+0200',
    CCT   => '+0630',
    CDT   => '-0500',
    CEDT  => '+0200',
    CEST  => '+0200',
    CET   => '+0100',
    CHADT => '+1345',
    CHAST => '+1245',
    CHOT  => '+0800',
    CHUT  => '+1000',
    CIST  => '-0800',
    CIT   => '+0800',
    CKT   => '-1000',
    CLST  => '-0300',
    CLT   => '-0400',
    COST  => '-0400',
    COT   => '-0500',
    CST   => '-0600',
    CT    => '+0800',
    CVT   => '-0100',
    CWST  => '+0845',
    CXT   => '+0700',
    ChST  => '+1000',
    DAVT  => '+0700',
    DDUT  => '+1000',
    DFT   => '+0100',
    EASST => '-0500',
    EAST  => '-0600',
    EAT   => '+0300',
    ECT   => '-0400',
    EDT   => '-0400',
    EEDT  => '+0300',
    EEST  => '+0300',
    EET   => '+0200',
    EGST  => '+0000',
    EGT   => '-0100',
    EIT   => '+0900',
    EST   => '-0500',
    FET   => '+0300',
    FJT   => '+1200',
    FKST  => '-0300',
    FKT   => '-0400',
    FNT   => '-0200',
    GALT  => '-0600',
    GAMT  => '-0900',
    GET   => '+0400',
    GFT   => '-0300',
    GILT  => '+1200',
    GIT   => '-0900',
    GMT   => '+0000',
    GST   => '-0200',
    GYT   => '-0400',
    HADT  => '-0900',
    HAEC  => '+0200',
    HAST  => '-1000',
    HKT   => '+0800',
    HMT   => '+0500',
    HOVT  => '+0700',
    HST   => '-1000',
    ICT   => '+0700',
    IDT   => '+0300',
    IOT   => '+0300',
    IRDT  => '+0430',
    IRKT  => '+0900',
    IRST  => '+0330',
    IST   => '+0530',
    JST   => '+0900',
    KGT   => '+0600',
    KOST  => '+1100',
    KRAT  => '+0700',
    KST   => '+0900',
    LHST  => '+1030',
    LINT  => '+1400',
    MAGT  => '+1200',
    MART  => '-0930',
    MAWT  => '+0500',
    MDT   => '-0600',
    MEST  => '+0200',
    MET   => '+0100',
    MHT   => '+1200',
    MIST  => '+1100',
    MIT   => '-0930',
    MMT   => '+0630',
    MSK   => '+0400',
    MST   => '-0700',
    MUT   => '+0400',
    MVT   => '+0500',
    MYT   => '+0800',
    NCT   => '+1100',
    NDT   => '-0230',
    NFT   => '+1130',
    NPT   => '+0545',
    NST   => '-0330',
    NT    => '-0330',
    NUT   => '-1100',
    NZDT  => '+1300',
    NZST  => '+1200',
    OMST  => '+0700',
    ORAT  => '-0500',
    PDT   => '-0700',
    PET   => '-0500',
    PETT  => '+1200',
    PGT   => '+1000',
    PHOT  => '+1300',
    PKT   => '+0500',
    PMDT  => '-0200',
    PMST  => '-0300',
    PONT  => '+1100',
    PST   => '-0800',
    PYST  => '-0300',
    PYT   => '-0400',
    RET   => '+0400',
    ROTT  => '-0300',
    SAKT  => '+1100',
    SAMT  => '+0400',
    SAST  => '+0200',
    SBT   => '+1100',
    SCT   => '+0400',
    SGT   => '+0800',
    SLST  => '+0530',
    SRT   => '-0300',
    SST   => '-1100',
    SYOT  => '+0300',
    TAHT  => '-1000',
    TFT   => '+0500',
    THA   => '+0700',
    TJT   => '+0500',
    TKT   => '+1300',
    TLT   => '+0900',
    TMT   => '+0500',
    TOT   => '+1300',
    TVT   => '+0500',
    UCT   => '+0000',
    ULAT  => '+0800',
    UTC   => '+0000',
    UYST  => '-0200',
    UYT   => '-0300',
    UZT   => '+0500',
    VET   => '-0430',
    VLAT  => '+1000',
    VOLT  => '+0400',
    VOST  => '+0600',
    VUT   => '+1100',
    WAKT  => '+1200',
    WAST  => '+0200',
    WAT   => '+0100',
    WEDT  => '+0100',
    WEST  => '+0100',
    WET   => '+0000',
    WIT   => '+0700',
    WST   => '+0800',
    YAKT  => '+1000',
    YEKT  => '+0600',
    Z     => '+0000',
);
my $tz_strings = join('|', keys %tz_offsets);
my $tz_suffixes = qr#(?:[+-][0-9]{4})|$tz_strings#i;

my $date_standard = qr#$short_day_of_week $short_month\s{1,2}$date_number $time_24h $tz_suffixes [0-9]{4}#i;
my $date_standard_matches = qr#$short_day_of_week (?<m>$short_month)\s{1,2}(?<d>$date_number) (?<t>$time_24h) (?<tz>$tz_suffixes) (?<y>[0-9]{4})#i;

# formats parsed by vague datestring, without colouring
# the context of the code using it
my $descriptive_datestring = qr{
    (?:(?:next|last)\s(?:$month_regex)) |                        # next June, last jan
    (?:(?:$month_regex)\s(?:[0-9]{4})) |                         # Jan 2014, August 2000
    (?:(?:$date_number)\s?$number_suffixes?\s(?:$month_regex)) | # 18th Jan, 01 October
    (?:(?:$month_regex)\s(?:$date_number)\s?$number_suffixes?) | # Dec 25, July 4th
    (?:$month_regex) |                                           # February, Aug
    }ix;

# Used for parse_descriptive_datestring_to_date
my $descriptive_datestring_matches = qr#
    (?:(?<q>next|last)\s(?<m>$month_regex)) |
    (?:(?<m>$month_regex)\s(?<y>[0-9]{4})) |
    (?:(?<d>$date_number)\s?$number_suffixes?\s(?<m>$month_regex)) |
    (?:(?<m>$month_regex)\s(?<d>$date_number)\s?$number_suffixes?) |
    (?<m>$month_regex)
    #ix;

my $formatted_datestring = build_datestring_regex();

# Accessors for useful regexes
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

# Accessors for matching regexes
# These matches are for "in the right format"/"looks about right"
#  not "are valid dates"; expects normalised whitespace
sub datestring_regex {
    return qr#$formatted_datestring|$descriptive_datestring#i;
}

sub descriptive_datestring_regex {
    return $descriptive_datestring;
}

sub formatted_datestring_regex {
    return $formatted_datestring;
}

# Called once to build $formatted_datestring
sub build_datestring_regex {
    my @regexes = ();

    ## unambigous and awesome date formats:
    # ISO8601: 2014-11-27 (with a concession to single-digit month and day numbers)
    push @regexes, qr#[0-9]{4}-?[0-1]?[0-9]-?$date_number(?:[ T]$time_24h)?(?: ?$tz_suffixes)?#i;

    # HTTP: Sat, 09 Aug 2014 18:20:00
    push @regexes, qr#$short_day_of_week, [0-9]{2} $short_month [0-9]{4} $time_24h?#i;

    # RFC850 08-Feb-94 14:15:29 GMT
    push @regexes, qr#[0-9]{2}-$short_month-(?:[0-9]{2}|[0-9]{4}) $time_24h?(?: ?$tz_suffixes)#i;

    # RFC2822 Sat, 13 Mar 2010 11:29:05 -0800
    push @regexes, qr#$short_day_of_week, $date_number $short_month [0-9]{4} $time_24h $tz_suffixes#i;

    # date(1) default format Sun Sep  7 15:57:56 EDT 2014
    push @regexes, $date_standard;

    # month-first date formats
    push @regexes, qr#$date_number$date_delim$short_month$date_delim[0-9]{4}#i;
    push @regexes, qr#$date_number$date_delim$full_month$date_delim[0-9]{4}#i;
    push @regexes, qr#(?:$short_month|$full_month) $date_number(?: ?$number_suffixes)?[,]? [0-9]{4}#i;

    # day-first date formats
    push @regexes, qr#$short_month$date_delim$date_number$date_delim[0-9]{4}#i;
    push @regexes, qr#$full_month$date_delim$date_number$date_delim[0-9]{4}#i;
    push @regexes, qr#$date_number[,]?(?: ?$number_suffixes)? (?:$short_month|$full_month)[,]? [0-9]{4}#i;

    ## Ambiguous, but potentially valid date formats
    push @regexes, $ambiguous_dates;

    my $returned_regex = join '|', @regexes;
    return qr/$returned_regex/i;
}

# Parses any string that *can* be parsed to a date object
sub parse_datestring_to_date {
    my ($d) = @_;

    return parse_formatted_datestring_to_date($d) || parse_descriptive_datestring_to_date($d);
}

# Accepts a string which looks like date per the supplied datestring_regex (e.g. '31/10/1980')
# Returns a DateTime object representing that date or `undef` if the string cannot be parsed.
sub parse_formatted_datestring_to_date {
    my ($d) = @_;

    return unless ($d =~ qr/^$formatted_datestring$/);    # Only handle white-listed strings, even if they might otherwise work.
    if ($d =~ $ambiguous_dates_matches) {
        # guesswork for ambigous DMY/MDY and switch to ISO
        my ($month, $day, $year) = ($+{'m'}, $+{'d'}, $+{'y'});    # Assume MDY, even though it's crazy, for backward compatibility

        if ($month > 12) {
            # Months over 12 don't make any sense, so must not be MDY
            return if ($day > 12);                                 # what we took as day must not be month, either.  No idea how to proceed.
            ($day, $month) = ($month, $day);                       # month and day must be swapped, then.
        }

        $d = sprintf("%04d-%02d-%02d", $year, $month, $day);
    } elsif ($d =~ $date_standard_matches) {
        # To ISO8601 for parsing
        $d = sprintf('%04d-%02d-%02dT%s%s', $+{'y'}, $short_month_to_number{lc $+{'m'}}, $+{'d'}, $+{'t'}, $tz_offsets{$+{'tz'}});
    }

    $d =~ s/(\d+)\s?$number_suffixes/$1/i;                                       # Strip ordinal text.
    $d =~ s/,//i;                                                                # Strip any random commas.
    $d =~ s/($full_month)/$full_month_to_short{lc $1}/i;                         # Parser deals better with the shorter month names.
    $d =~ s/^($short_month)$date_delim(\d{1,2})/$2-$short_month_fix{lc $1}/i;    # Switching Jun-01-2012 to 01 Jun 2012

    my $maybe_date_object = try { DateTime::Format::HTTP->parse_datetime($d) };  # Don't die no matter how bad we did with checking our string.

    return $maybe_date_object;
}

# parses multiple dates and guesses the consistent format over the set;
# i.e. defaults to m/d/y unless one of them is obviously d/m/y then it'll
# treat them all as d/m/y
sub parse_all_datestrings_to_date {
    my @dates = @_;

    # If there is an ambiguous date with a "month" over 12 in the set, we need to flip.
    my $flip_d_m = first { /$ambiguous_dates_matches/ && $+{'m'} > 12 } @dates;

    my @dates_to_return;
    foreach my $date (@dates) {
        if ($date =~ $ambiguous_dates_matches) {
            my ($month, $day, $year) = ($+{'m'}, $+{'d'}, $+{'y'});
            ($day, $month) = ($month, $day) if $flip_d_m;
            return if $month > 12;    #there's a mish-mash of formats; give up
            $date = "$year-$month-$day";
        }
        my $date_object = parse_datestring_to_date($date);
        return unless $date_object;
        push @dates_to_return, $date_object;
    }

    return @dates_to_return;
}

# Parses a really vague description and basically guesses
sub parse_descriptive_datestring_to_date {
    my ($string) = @_;

    return unless ($string =~ qr/^$descriptive_datestring_matches$/);

    my $now = DateTime->now();
    my $month = $+{'m'}; # Set in each alternative match.
    
    if (my $day = $+{'d'}) {
        return parse_datestring_to_date("$day $month ".$now->year());
    }
    elsif (my $relative_dir = $+{'q'}) {
        my $tmp_date = parse_datestring_to_date("01 $month ".$now->year());
        # next <month>
        $tmp_date->add( years => 1) if ($relative_dir eq "next" && DateTime->compare($tmp_date, $now) != 1);
        # last <month>
        $tmp_date->add( years => -1) if ($relative_dir eq "last" && DateTime->compare($tmp_date, $now) != -1);
        return $tmp_date;
    }
    elsif (my $year = $+{'y'}) {
        # Month and year is the first of that month.
        return parse_datestring_to_date("01 $month $year");
    }
    else {
        # single named months
        # "january" in january means the current month
        # otherwise it always means the coming month of that name, be it this year or next year
        return parse_datestring_to_date("01 ".$now->month()." ".$now->year()) if lc($now->month_name()) eq lc($month);
        my $this_years_month = parse_datestring_to_date("01 $month ".$now->year());
        $this_years_month->add( years => 1 ) if (DateTime->compare($this_years_month, $now) == -1);
        return $this_years_month;
    }
}

# Takes a DateTime object (or a string which can be parsed into one)
# and returns a standard formatted output string or an empty string if it cannot be parsed.
sub date_output_string {
    my $dt = shift;

    my $ddg_format = "%d %b %Y";    # Just here to make it easy to see.
    my $string     = '';            # By default we've got nothing.

    # They didn't give us a DateTime object, let's try to make one from whatever we got.
    $dt = parse_datestring_to_date($dt) if (ref($dt) !~ /DateTime/);

    $string = $dt->strftime($ddg_format) if ($dt);

    return $string;
}

1;
