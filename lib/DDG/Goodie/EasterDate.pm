package DDG::Goodie::EasterDate;
# ABSTRACT: Show easter date for the specified year

use DDG::Goodie;
use DateTime;

use strict;
use warnings;

zci answer_type => "easter_date";
zci is_cached   => 1;

name "EasterDate";
description "Show easter date for the specified year";
primary_example_queries "Easter 2015", "Easter date";
secondary_example_queries "easter date 1995", "Easter 1995 date", "Passover 2016", "Rosh Hashanah 2014";
category "dates";
topics "everyday";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/EasterDate.pm";
attribution github => ["https://github.com/W25", "W25"];

# Triggers
triggers any => 'easter', 'purim', 'shavuot', 'passover', 'pesach', 'rosh hashana', 'rosh hashanah',
                'yom kippur', 'sukkot', 'hanukkah', 'chanukkah',
                'jewish holidays', 'hebrew holidays', 'holidays in israel';


my @month_names = qw(January February March April May June
    July August September October November December);

sub output_date {
    my ($month, $day) = @_;
    
    return "$day " . $month_names[$month - 1];
}

# Based on http://www.strchr.com/calendar

sub roshhashanah {
    # Gauss algorithm
    my $y = shift;
    
    my $r = (12 * $y + 12) % 19;

    # Calculate the number of parts (Talmudic units)
    my $parts = 765433 * $r - 1565 * $y - 445405 + 123120 * ($y % 4);
    
    # Take into account the difference between Gregorian and Julian calendars
    my $gregorian_shift = int($y / 100) - int ($y / 400) - 2;
    
    $parts -= 492479 if $parts <= 0; # Floored division
    
    my $day = int($parts / 492480) + $gregorian_shift;
    
    $parts %= 492480;
    
    my $dow = ($y + int($y / 4) - $gregorian_shift + $day + 2) % 7;
    
    # Postponement rules
    if ($dow == 0 || $dow == 3 || $dow == 5) {
        $day++;
    } elsif ($dow == 1 && $parts >= 442111 && $r > 11) {
        $day++;
    } elsif ($dow == 2 && $parts >= 311676 && $r > 6) {
        $day += 2;
    }
    
    # Calculate month and day
    return (8, $day + 31) if $day <= 0;
    
    return (10, $day - 30) if $day > 30;
    
    return (9, $day);
}


# Deltas relative to Rosh Hashanah
use constant {
    HOLIDAY_PURIM => -193,
    HOLIDAY_SHAVUOT => -113,
    HOLIDAY_PASSOVER => -163,
    HOLIDAY_ROSH_HASHANAH => 0,
    HOLIDAY_YOM_KIPPUR => 9,
    HOLIDAY_SUKKOT => 14,
    HOLIDAY_HANUKKAH => 83,
};

sub jewish_holiday {
    my ($year, $delta) = @_;
    my ($month, $day) = roshhashanah($year);
    
    my $dt = DateTime->new(year => $year, month => $month, day => $day);
    
    if ($delta == HOLIDAY_HANUKKAH) {
        ($month, $day) = roshhashanah($year + 1);
    
        my $next = DateTime->new(year => $year + 1, month => $month, day => $day);

        my $year_length = $next->delta_days($dt)->delta_days();

        $delta++ if $year_length == 355 || $year_length == 385; # Heshvan is one day longer in a complete year
    }
    
    $dt->add( days => $delta );
    
    return ($dt->month, $dt->day);
}

sub easter {
    # Gauss algorithm
    my ($year, $is_western) = @_;
    
    # Calculate the difference between Julian and Gregorian calendars for the given year
    my $century = int($year / 100);
    my $gregorian_shift = $century - int ($century / 4) - 2;
    
    my ($x, $y) = (15, 6);
        
    if ($is_western) {
        $x = 17 - int ((13 + 8 * $century) / 25) + $gregorian_shift; # Metonic cycle correction
        $y += $gregorian_shift;
    }
    
    my $d = ( ($year % 19) * 19 + $x) % 30; # Paschal Full Moon
    my $e = ( 2 * ($year % 4) + 4 * $year - $d + $y) % 7; # Sunday after PFM
    
    my $r = $d + $e;
    
    $r += $gregorian_shift if !$is_western;
    
    if ($r >= 40) {
        return ( 5, $r - 39 );
    } elsif ($r >= 10) {
        # Correction for the length of the moon month
        $r -= 7 if $e == 6 && ($d == 29 || $d == 28 && ($year % 19) > 10);
        return ( 4, $r - 9 );
    } else {
        return ( 3, $r + 22 );
    }
}

my %jewish_holidays = (
    'Purim' => HOLIDAY_PURIM,
    'Passover' => HOLIDAY_PASSOVER, 'Pesach' => HOLIDAY_PASSOVER,
    'Shavuot' => HOLIDAY_SHAVUOT,
    'Rosh Hashanah' => HOLIDAY_ROSH_HASHANAH, 'Rosh Hashana' => HOLIDAY_ROSH_HASHANAH,
    'Yom Kippur' => HOLIDAY_YOM_KIPPUR,
    'Sukkot' => HOLIDAY_SUKKOT,
    'Hanukkah' => HOLIDAY_HANUKKAH, 'Chanukkah' => HOLIDAY_HANUKKAH,
);

my $jewish_regex = join('|', keys %jewish_holidays);
$jewish_regex =~ s/ /\\s+/g;

my $holiday = qr/(?<h>catholic\s+easter| orthodox\s+easter| protestant\s+easter| easter |
               $jewish_regex | jewish\s+holidays | hebrew\s+holidays | holidays\s+in\s+israel)/ix;

# Handle statement
handle query_raw => sub {
    my $result;
    
    # Read the input
    return unless /^(?:$holiday\s+
            ((?:date) (?:\s+(?<y>\d{4}))? |
             (?<y>\d{4}) (?:\s+date)?
            )|
            (?:date\s+of| when\s+is) \s+$holiday (?:\s+(?<y>\d{4}))?)$/ix;
            
    my $year = defined $+{y} ? $+{y} : ((localtime)[5] + 1900);
    return if ($year < 1800 || $year > 2299);
    
    my $operation = $+{h};
    $operation =~ s/(\w+)/\u\L$1/g; # title case
    
    # Calculate the dates
    if ($operation eq 'Easter') {
        $result = 'Western: ' . output_date(easter($year, 1)) . ', Orthodox: ' . output_date(easter($year, 0));
        
    } elsif ($operation eq 'Catholic Easter' || $operation eq 'Protestant Easter') {
        $result = output_date(easter($year, 1));
        
    } elsif ($operation eq 'Orthodox Easter') {
        $result = output_date(easter($year, 0));
        
    } elsif (exists $jewish_holidays{$operation}) {
        $result = output_date(jewish_holiday($year, $jewish_holidays{$operation}));
            
    } elsif ($operation eq 'Jewish Holidays') {
        $result = 'Purim: ' . output_date(jewish_holiday($year, HOLIDAY_PURIM)) .
                  ', Passover: ' . output_date(jewish_holiday($year, HOLIDAY_PASSOVER)) .
                  ', Shavuot: ' . output_date(jewish_holiday($year, HOLIDAY_SHAVUOT)) .
                  ', Rosh Hashanah: ' . output_date(jewish_holiday($year, HOLIDAY_ROSH_HASHANAH)) .
                  ', Yom Kippur: ' . output_date(jewish_holiday($year, HOLIDAY_YOM_KIPPUR)) .
                  ', Sukkot: ' . output_date(jewish_holiday($year, HOLIDAY_SUKKOT)) .
                  ', Hanukkah: ' . output_date(jewish_holiday($year, HOLIDAY_HANUKKAH));
        
    } else {
        return;
    }

    return $result,
        structured_answer => {
            input => [$year],
            operation => $operation,
            result => $result,
        };
};

1;
