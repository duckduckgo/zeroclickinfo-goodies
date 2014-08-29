package DDG::GoodieRole::Dates;
# ABSTRACT: A role to allow Goodies to recognize and work with dates in different notations.

use strict;
use warnings;
use feature 'state';

use Moo::Role;

use DateTime;
use List::Util qw( first );
use Try::Tiny;

# This appears to parse most/all of the big ones, however it doesn't present a regex
use DateTime::Format::HTTP;

# Reused lists and components for below
my $short_day_of_week   = qr#Mon|Tue|Wed|Thu|Fri|Sat|Sun#i;
my $full_day_of_week   = qr#Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday#i;
my %full_month_to_short = map { lc $_ => substr($_, 0, 3) } qw(January February March April May June July August September October November December);
my %short_month_fix     = map { lc $_ => $_ } (values %full_month_to_short);
my $short_month         = qr#Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec#i;
my $full_month          = qr#January|February|March|April|May|June|July|August|September|October|November|December#i;
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
my $tz_suffixes = qr#(?:[+-][0-9]{4})|ACDT|ACST|ACT|ADT|AEDT|AEST|AFT|AKDT|AKST|AMST|AMT|ART|AST|AWDT|AWST|AZOST|AZT|BDT|BIOT|BIT|BOT|BRT|BST|BTT|CAT|CCT|CDT|CEDT|CEST|CET|CHADT|CHAST|CHOT|CHUT|CIST|CIT|CKT|CLST|CLT|COST|COT|CST|CT|CVT|CWST|CXT|ChST|DAVT|DDUT|DFT|EASST|EAST|EAT|ECT|EDT|EEDT|EEST|EET|EGST|EGT|EIT|EST|FET|FJT|FKST|FKT|FNT|GALT|GAMT|GET|GFT|GILT|GIT|GMT|GST|GYT|HADT|HAEC|HAST|HKT|HMT|HOVT|HST|ICT|IDT|IOT|IRDT|IRKT|IRST|IST|JST|KGT|KOST|KRAT|KST|LHST|LINT|MAGT|MART|MAWT|MDT|MEST|MET|MHT|MIST|MIT|MMT|MSK|MST|MUT|MVT|MYT|NCT|NDT|NFT|NPT|NST|NT|NUT|NZDT|NZST|OMST|ORAT|PDT|PET|PETT|PGT|PHOT|PHT|PKT|PMDT|PMST|PONT|PST|PYST|PYT|RET|ROTT|SAKT|SAMT|SAST|SBT|SCT|SGT|SLST|SRT|SST|SYOT|TAHT|TFT|THA|TJT|TKT|TLT|TMT|TOT|TVT|UCT|ULAT|UTC|UYST|UYT|UZT|VET|VLAT|VOLT|VOST|VUT|WAKT|WAST|WAT|WEDT|WEST|WET|WIT|WST|YAKT|YEKT|Z#i;
# Accessors for useful regexes
sub full_month_regex {
    return $full_month;
}
sub short_month_regex {
    return $short_month;
}
sub month_regex {
    return qr/$full_month|$short_month/;
}
sub full_day_of_week_regex {
    return $full_day_of_week;
}
sub short_day_of_week_regex {
    return $short_day_of_week;
}

# These matches are for "in the right format"/"looks about right"
#  not "are valid dates"; expects normalised whitespace
sub date_regex {
    my @regexes = ();

    ## unambigous and awesome date formats:
    # ISO8601: 2014-11-27 (with a concession to single-digit month and day numbers)
    push @regexes, qr#[0-9]{4}-?[0-1]?[0-9]-?$date_number(?:[ T]$time_24h)?(?: ?$tz_suffixes)?#i;

    # HTTP: Sat, 09 Aug 2014 18:20:00
    push @regexes, qr#$short_day_of_week, [0-9]{2} $short_month [0-9]{4} $time_24h?#i;

    # RFC850 08-Feb-94 14:15:29 GMT
    push @regexes, qr#[0-9]{2}-$short_month-(?:[0-9]{2}|[0-9]{4}) $time_24h?(?: ?$tz_suffixes)#i;

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

    state $returned_regex = join '|', @regexes;
    return qr/$returned_regex/i;
}

# Accepts a string which looks like date per the supplied date_regex (e.g. '31/10/1980')
# Returns a DateTime object representing that date or `undef` if the string cannot be parsed.
sub parse_string_to_date {
    my ($d) = @_;

    return unless ($d =~ date_regex());    # Only handle white-listed strings, even if they might otherwise work.
    if ($d =~ $ambiguous_dates_matches) {
        # guesswork for ambigous DMY/MDY and switch to ISO
        my ($month, $day, $year) = ($+{'m'}, $+{'d'}, $+{'y'});    # Assume MDY, even though it's crazy, for backward compatibility

        if ($month > 12) {
            # Months over 12 don't make any sense, so must not be MDY
            return if ($day > 12);                                 # what we took as day must not be month, either.  No idea how to proceed.
            ($day, $month) = ($month, $day);                       # month and day must be swapped, then.
        }

        $d = sprintf("%04d-%02d-%02d", $year, $month, $day);
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
sub parse_all_strings_to_date {
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
        my $date_object = parse_string_to_date($date);
        return unless $date_object;
        push @dates_to_return, $date_object;
    }

    return @dates_to_return;
}


# Takes a DateTime object (or a string which can be parsed into one)
# and returns a standard formatted output string or an empty string if it cannot be parsed.
sub date_output_string {
    my $dt = shift;

    my $ddg_format = "%d %b %Y";    # Just here to make it easy to see.
    my $string     = '';            # By default we've got nothing.

    # They didn't give us a DateTime object, let's try to make one from whatever we got.
    $dt = parse_string_to_date($dt) if (ref($dt) !~ /DateTime/);

    $string = $dt->strftime($ddg_format) if ($dt);

    return $string;
}

# Parses a really vague description and basically guesses
sub parse_vague_string_to_date {
    my ($string) = @_;
    if($string =~ qr#(?:(?<q>next|last)\s(?<m>$full_month|$short_month))|(?:(?<m>$full_month|$short_month)\s(?<y>[0-9]{4}))|(?<m>$full_month|$short_month)#i) {
        my $now = DateTime->now();
        my $month = $+{'m'}; # Set in each alternative match.
        if (my $relative_dir = $+{'q'}) {
            my $tmp_date = parse_string_to_date("01 $month ".$now->year());
            # next <month>
            $tmp_date->add( years => 1) if ($relative_dir eq "next" && DateTime->compare($tmp_date, $now) != 1);
            # last <month>
            $tmp_date->add( years => -1) if ($relative_dir eq "last" && DateTime->compare($tmp_date, $now) != -1);
            return $tmp_date;
        }
        elsif (my $year = $+{'y'}) {
            # Month and year is the first of that month.
            return parse_string_to_date("01 $month $year");
        }
        else {
            # single named months
            # "january" in january means the current month
            # otherwise it always means the coming month of that name, be it this year or next year
            return parse_string_to_date("01 ".$now->month()." ".$now->year()) if lc($now->month_name()) eq lc($month);
            my $this_years_month = parse_string_to_date("01 $month ".$now->year());
            $this_years_month->add( years => 1 ) if (DateTime->compare($this_years_month, $now) == -1);
            return $this_years_month;
        }
    }
    return;
}

1;
