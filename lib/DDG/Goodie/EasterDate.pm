package DDG::Goodie::EasterDate;
# ABSTRACT: Show moveable holidays for the specified year
# https://en.wikipedia.org/wiki/Category:Moveable_holidays

use DDG::Goodie;
use DateTime;

use strict;
use warnings;

zci answer_type => "easter_date";
zci is_cached   => 0;

name "EasterDate";
description "Show easter date for the specified year";
primary_example_queries "Easter 2015", "Easter date", "Rosh Hashanah 2014";
secondary_example_queries "easter date 1995", "Orthodox Easter 1995 date", "Passover 2016", "good friday 2015";
category "dates";
topics "everyday";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/EasterDate.pm";
attribution github => ["https://github.com/W25", "W25"];

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

my %jewish_holidays = (
    'Purim' => HOLIDAY_PURIM,
    'Passover' => HOLIDAY_PASSOVER, 'Pesach' => HOLIDAY_PASSOVER,
    'Shavuot' => HOLIDAY_SHAVUOT,
    'Rosh Hashanah' => HOLIDAY_ROSH_HASHANAH, 'Rosh Hashana' => HOLIDAY_ROSH_HASHANAH,
    'Yom Kippur' => HOLIDAY_YOM_KIPPUR,
    'Sukkot' => HOLIDAY_SUKKOT,
    'Hanukkah' => HOLIDAY_HANUKKAH, 'Chanukkah' => HOLIDAY_HANUKKAH,
);

my %christian_holidays = (
    'Good Friday' => -2,
    'Easter' => 0,
    'Ascension' => 39, 'Ascension Day' => 39, 'Ascension Thursday' => 39,
    'Pentecost' => 49,
    'Trinity Sunday' => 56, # Equal to Pentecost in Orthodox church
    'Corpus Christi' => 60, # Not observed by Orthodox church
);

# Countries where Orthodox Christianity is more common than Western Christianity
# according to https://en.wikipedia.org/wiki/Eastern_Orthodox_Church
my %orthodox_countries;
@orthodox_countries{qw(BY BG CY GE GR MK MD ME RO RU RS UA BA AL KZ IL JO PS LB SY AM TM UZ)} = ();

# Triggers
triggers any => 'jewish holidays', 'hebrew holidays', (map {lc($_)} keys %jewish_holidays, keys %christian_holidays);



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
    
    # Return DateTime object
    my $dt = DateTime->new(year => $y, month => 8, day => 31);
    $dt->add( days => $day );
    return $dt;
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
    
    # Correction for the length of the moon month
    $r -= 7 if $e == 6 && ($d == 29 || $d == 28 && ($year % 19) > 10);
    
    # Return DateTime object
    my $dt = DateTime->new(year => $year, month => 3, day => 22);
    $dt->add( days => $r );
    return $dt;
}

sub jewish_holiday {
    my ($year, $delta) = @_;
    
    my $dt = roshhashanah($year);
    
    if ($delta == HOLIDAY_HANUKKAH) {
        my $next = roshhashanah($year + 1);
    
        my $year_length = $next->delta_days($dt)->delta_days();

        $delta++ if $year_length == 355 || $year_length == 385; # Heshvan is one day longer in a complete year
    }
    
    $dt->add( days => $delta );
    
    return $dt;
}

# A holiday related to easter
sub christian_holiday {
    my ($year, $is_western, $delta) = @_;
    
    # Trinity Sunday is equal to Pentecost in Orthodox church
    $delta = $christian_holidays{'Pentecost'} if $delta == $christian_holidays{'Trinity Sunday'} && !$is_western;
    
    # Corpus Christi is not observed by Orthodox church
    $is_western = 1 if $delta == $christian_holidays{'Corpus Christi'} && !$is_western;
    
    my $dt = easter($year, $is_western);
    
    $dt->add( days => $delta );
    
    return ($dt, $is_western);
}

sub output_date {
    my $dt = shift;
    
    return $dt->format_cldr('d MMMM');
}

my $jewish_regex = join('|', keys %jewish_holidays);
$jewish_regex =~ s/ /\\s+/g;

my $christian_regex = join('|', keys %christian_holidays);
$christian_regex =~ s/ /\\s+/g;

my $holiday = qr/(?:
                     (?: (?<d>catholic | orthodox | protestant | western | eastern) \s+ )? (?<h> $christian_regex) |
                     (?<h> $jewish_regex | jewish\s+holidays | hebrew\s+holidays)
                 )/ix;

# Handle statement
handle query_raw => sub {
    my $result;
    
    # Read the input
    return unless /^(?:$holiday \s+
            ((?:date) (?:\s+(?<y>\d{4}))? |
             (?<y>\d{4}) (?:\s+date)?
            )|
            (?:date\s+of| when\s+is) \s+$holiday (?:\s+(?<y>\d{4}))?)$/ix;
            
    my $year = defined $+{y} ? $+{y} : ((localtime)[5] + 1900);
    return if ($year < 1800 || $year > 2299);
    
    my $denomination = defined $+{d} ? lc $+{d} : '';
    
    my $operation = $+{h};
    $operation =~ s/(\w+)/\u\L$1/g; # title case
    
    # Calculate the dates
    if (exists $jewish_holidays{$operation}) {
        $result = output_date(jewish_holiday($year, $jewish_holidays{$operation}));
        
    } elsif (exists $christian_holidays{$operation}) {
        # Find the most likely Christianity branch in this country using Location API
        my $is_western = !exists $orthodox_countries{$loc->country_code};
        if ($denomination) {
            $is_western = $denomination ne 'orthodox' && $denomination ne 'eastern';
        }
        
        my $dt; # the is_western flag may be changed by the christian_holiday function
        ($dt, $is_western) = christian_holiday($year, $is_western, $christian_holidays{$operation});
        $result = output_date($dt);
        $operation .= $is_western ? ' (Western Christianity)' : ' (Orthodox Christianity)';
        
    } elsif ($operation eq 'Jewish Holidays' || $operation eq 'Hebrew Holidays') {
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
