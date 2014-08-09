package DDG::GoodieRole::Dates;

use strict;
use warnings;

use Moo::Role;
use DateTime;

# This appears to parse most/all of the big ones, however it doesn't present a regex
use DateTime::Format::HTTP;

# Reused lists and components for below
my $day_of_week = qr#Mon|Tue|Wed|Thu|Fri|Sat|Sun#i;
my %long_to_short = map { lc $_ => substr($_, 0, 3) } qw(January February March April May June July August September October November December);
my $short_month = qr#Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec#i;
my $full_month = qr#January|February|March|April|May|June|July|August|September|October|November|December#i;
my $time_24h = qr#(?:(?:[0-1][0-9])|(?:2[0-3]))[:]?[0-5][0-9][:]?[0-5][0-9]#i;
my $time_12h = qr#(?:(?:0[1-9])|(?:1[012])):[0-5][0-9]:[0-5][0-9]\s?(?:am|pm)#i;

# like: 1st 2nd 3rd 4-20,24-30th 21st 22nd 23rd 31st
my $number_suffixes = qr#(st|nd|rd|th)#i;

# Timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations
my $tz_suffixes = qr#(?:[+-][0-9]{4})|ACDT|ACST|ACT|ADT|AEDT|AEST|AFT|AKDT|AKST|AMST|AMST|AMT|AMT|ART|AST|AST|AWDT|AWST|AZOST|AZT|BDT|BIOT|BIT|BOT|BRT|BST|BST|BTT|CAT|CCT|CDT|CDT|CEDT|CEST|CET|CHADT|CHAST|CHOT|CHUT|CIST|CIT|CKT|CLST|CLT|COST|COT|CST|CST|CST|CST|CST|CT|CVT|CWST|CXT|ChST|DAVT|DDUT|DFT|EASST|EAST|EAT|ECT|ECT|EDT|EEDT|EEST|EET|EGST|EGT|EIT|EST|EST|FET|FJT|FKST|FKST|FKT|FNT|GALT|GAMT|GET|GFT|GILT|GIT|GMT|GST|GST|GYT|HADT|HAEC|HAST|HKT|HMT|HOVT|HST|ICT|IDT|IOT|IRDT|IRKT|IRST|IST|IST|IST|JST|KGT|KOST|KRAT|KST|LHST|LHST|LINT|MAGT|MART|MAWT|MDT|MEST|MET|MHT|MIST|MIT|MMT|MSK|MST|MST|MST|MUT|MVT|MYT|NCT|NDT|NFT|NPT|NST|NT|NUT|NZDT|NZST|OMST|ORAT|PDT|PET|PETT|PGT|PHOT|PHT|PKT|PMDT|PMST|PONT|PST|PYST|PYT|RET|ROTT|SAKT|SAMT|SAST|SBT|SCT|SGT|SLST|SRT|SST|SST|SYOT|TAHT|TFT|THA|TJT|TKT|TLT|TMT|TOT|TVT|UCT|ULAT|UTC|UYST|UYT|UZT|VET|VLAT|VOLT|VOST|VUT|WAKT|WAST|WAT|WEDT|WEST|WET|WIT|WST|YAKT|YEKT|Z#i;

# These matches are for "in the right format"/"looks about right" 
#  not "are valid dates"; expects normalised whitespace
#  probably should be used with /i
sub date_regex {
    my @regexes = ();
    
    ## unambigous and awesome date formats: 
    # ISO8601: 2014-11-27
    push @regexes, qr#[0-9]{4}-?[0-1][0-9]-?[0-3][0-9]([ T]$time_24h)?( ?$tz_suffixes)?#i;
    
    # HTTP: Sat, 09 Aug 2014 18:20:00
    push @regexes, qr#$day_of_week, [0-9]{2} $short_month [0-9]{4} $time_24h?#i;
    
    # RFC850 08-Feb-94 14:15:29 GMT
    push @regexes, qr#[0-9]{2}-$short_month-([0-9]{2}|[0-9]{4}) $time_24h?( ?$tz_suffixes)#i;
    
    ## acceptable date formats
    # DMY: 27/11/2014 with a variety of delimiters and month formats
    push @regexes, qr#[0-3][0-9][\\/\._-][0-1][0-9][\\/\._-][0-9]{4}#i;
    push @regexes, qr#[0-3][0-9][\\/\._-]$short_month[\\/\._-][0-9]{4}#i;
    push @regexes, qr#[0-3][0-9][\\/\._-]$full_month[\\/\._-][0-9]{4}#i;
    push @regexes, qr#[0-3]?[0-9](?: ?$number_suffixes)? (?:$short_month|$full_month) [0-9]{4}#i;
    
    ## fundamentally non-sensical date formats, for americans
    # MDY: 11/27/2014
    push @regexes, qr#[0-1][0-9][\\/\,_-][0-3][0-9][\\/\,_-][0-9]{4}#i;
    push @regexes, qr#$short_month[\\/\,_-][0-3][0-9][\\/\,_-][0-9]{4}#i;
    push @regexes, qr#$full_month\\/\,_-][0-3][0-9][\\/\,_-][0-9]{4}#i;
    push @regexes, qr#(?:$short_month|$full_month) [0-3]?[0-9](?: ?$number_suffixes)? [0-9]{4}#i;
        
    my $returned_regex = join '|', @regexes;
    return qr/$returned_regex/i;
}

sub parse_string_to_date {
    my ($d) = @_;

    $d =~ s/(\d+)\s?$number_suffixes/$1/i;            # Strip ordinal text.
    $d =~ s/($full_month)/$long_to_short{lc $1}/i;    # Parser deals better with the shorter month names.
    return DateTime::Format::HTTP->parse_datetime($d);
}

1;
