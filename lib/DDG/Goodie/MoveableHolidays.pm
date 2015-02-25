package DDG::Goodie::MoveableHolidays;
# ABSTRACT: Show moveable holidays for the specified year

use DDG::Goodie;
use DateTime;
use Locale::Country;

use strict;
use warnings;
use utf8;

zci answer_type => "moveable_holiday";
zci is_cached   => 0; # easter date depends on user's location

name "MoveableHolidays";
description "Show moveable holidays for the specified year";
primary_example_queries "Easter 2015", "Easter date", "Rosh Hashanah 2014", "thanksgiving 2015", "Columbus Day date";
secondary_example_queries "easter date 1995", "Orthodox Easter 1995 date", "Passover 2016", "good friday 2015",
    "Programmers' Day 2015", "成人の日 2015"; # Coming of Age Day in Japan
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
    'Mardi Gras' => -47, 'Shrove Tuesday' => -47, 'Fat Tuesday' => -47, # Not observed by Orthodox church
    'Ash Wednesday' => -46, # Not observed by Orthodox church
    'Palm Sunday' => -7,
    'Good Friday' => -2,
    'Easter' => 0,
    'Ascension' => 39, 'Ascension Day' => 39, 'Ascension Thursday' => 39,
    'Pentecost' => 49,
    'Trinity Sunday' => 56, # Equal to Pentecost in Orthodox church
    'Corpus Christi' => 60, # Not observed by Orthodox church
);

# Source: https://en.wikipedia.org/wiki/Category:Moveable_holidays
my %moveable_holidays = ( # Format: country-code<month day_of_week week>
    # International
    'Autism Sunday' => '<2 7 2>',
    'International Beer Day' => '<8 5 1>',
    
    # https://en.wikipedia.org/wiki/Mother%27s_Day
    'Mother\'s Day' => 'US<5 7 2> NO<2 7 2> ES<5 7 1> AR<10 7 3> RU<11 7 0>',
    'Mothers Day'   => 'US<5 7 2> NO<2 7 2> ES<5 7 1> AR<10 7 3> RU<11 7 0>',
    'Mothers\' Day' => 'US<5 7 2> NO<2 7 2> ES<5 7 1> AR<10 7 3> RU<11 7 0>',
    
    # https://en.wikipedia.org/wiki/Children's_Day
    'Children\'s Day' => 'US<6 7 2> US<6 7 1> TH<1 6 2> NZ<3 7 1> ES<5 7 2> AU<10 6 4> ZA<11 6 1>',
    
    # https://en.wikipedia.org/wiki/Father%27s_Day#Dates_around_the_world
    'Father\'s Day' => 'US<6 7 3> RO<5 7 2> LT<6 7 1> AT<6 7 2> AU<9 7 1>',
    
    # https://en.wikipedia.org/wiki/Arbor_Day
    'Arbor Day' => 'US<4 5 0>',
    
    # US (https://en.wikipedia.org/wiki/Public_holidays_in_the_United_States)
    'Thanksgiving' => 'US<11 4 4> CA<10 1 2>',
    'Labor Day' => 'US<9 1 1>',
    'Columbus Day' => 'US<10 1 2>',
    'Memorial Day' => 'US<5 1 0>',
    'Washington\'s Birthday' => 'US<2 1 3>', 'Presidents Day' => 'US<2 1 3>', 'Presidents\' Day' => 'US<2 1 3>', 'President\'s Day' => 'US<2 1 3>',
    'Martin Luther King Day' => 'US<1 1 3>',
    
    'American Family Day' => 'US<8 7 1>',
    'Casimir Pulaski Day' => 'US<3 1 1>',
    'Pulaski Days' => 'US<10 5 1>',
    'Child Health Day' => 'US<10 1 1>',
    'Fraternal Day' => 'US<10 1 2>',
    'Hawaii Admission Day' => 'US<8 5 3>',
    'Indigenous Peoples\' Day' => 'US<10 1 2>',
    'Missouri Day' => 'US<10 3 3>',
    'National Day of Prayer' => 'US<5 4 1>',
    'National Day of Reason' => 'US<5 4 1>',
    'Nevada Day' => 'US<10 5 0>',
    'Patriots\' Day' => 'US<4 1 3>',
    'Pioneer Days' => 'US<5 6 1>', # https://en.wikipedia.org/wiki/Pioneer_Days_%28Chico,_California%29
    'Sweetest Day' => 'US<10 6 3>',
    
    'El Buen Fin' => 'MX<11 5 3>',
    
    'Guam Discovery Day' => 'GU<3 1 1>',
    
    'White Sunday' => 'WS<10 7 2>',
    
    # Australia
    'Canberra Day' => 'AU<3 2 1>',
    
    # Canada
    'Civic Holiday' => 'CA<8 1 1>',
    'Family Day' => 'CA<2 1 3>',
    
    'Commonwealth Day' => '<3 1 2>',
    'Handsel Monday' => 'UK<1 1 1>',
    
    'October Holiday' => 'IE<10 1 0>',
    
    # Japan (https://en.wikipedia.org/wiki/Public_holidays_in_Japan https://en.wikipedia.org/wiki/Happy_Monday_System)
    'Coming of Age Day' => 'JP<1 1 2>', '成人の日' => 'JP<1 1 2>',
    'Health and Sports Day' => 'JP<10 1 2>', '体育の日' => 'JP<10 1 2>',
    'Marine Day' => 'JP<7 1 3>', '海の日' => 'JP<7 1 3>',
    'Respect for the Aged Day' => 'JP<9 1 3>', '敬老の日' => 'JP<9 1 3>',
    
    'Saiō Matsuri' => 'JP<6 6 1>', '斎王まつり' => 'JP<6 6 1>',
    'Sanja Matsuri' => 'JP<5 6 3>', '三社祭' => 'JP<5 6 3>',
    'Tobata Gion Yamagasa' => 'JP<7 5 4>', '戸畑祇園山笠' => 'JP<7 5 4>',
    'Wasshoi Hyakuman Matsuri' => 'JP<8 6 1>', 'わっしょい百万夏祭り' => 'JP<8 6 1>',
    
    # Federal Day of Thanksgiving, Repentance and Prayer (Switzerland)
    'Bettag' => 'CH<2 1 3>', 'Jeûne fédéral' => 'CH<2 1 3>', 'Digiuno federale' => 'CH<2 1 3>', 'Rogaziun federala' => 'CH<2 1 3>',
    
    'Airborne March' => 'NL<9 6 1>', 'Airborne Wandeltocht' => 'NL<9 6 1>',
    
    'Kaatuneiden Muistopäivä' => 'FI<5 7 3>', # Commemoration Day of Fallen Soldiers (Finnland)
    
    'Day of Wallonia' => 'BE<9 7 3>', 'Fêtes de Wallonie' => 'BE<9 7 3>',
    
    'Ulcinj Day' => 'ME<4 6 1>', 'Dan Ulcinja' => 'ME<4 6 1>', 'Dita e Ulqinit' => 'ME<4 6 1>',
);

# Countries where Orthodox Christianity is more common than Western Christianity
# according to https://en.wikipedia.org/wiki/Eastern_Orthodox_Church
my %orthodox_countries;
@orthodox_countries{qw(BY BG CY GE GR MK MD ME RO RU RS UA BA AL KZ IL JO PS LB SY AM TM UZ)} = ();

# Triggers
triggers any => 'jewish holidays', 'hebrew holidays', 'programmers\' day', 'programmer\'s day', 'programmer day',
    (map {lc($_)} keys %jewish_holidays, keys %christian_holidays, keys %moveable_holidays);



# Based on http://www.strchr.com/calendar

sub roshhashanah {
    # Gauss algorithm
    my $year = shift;
    
    my $r = (12 * $year + 12) % 19;

    # Calculate the number of parts (Talmudic units)
    my $parts = 765433 * $r - 1565 * $year - 445405 + 123120 * ($year % 4);
    
    # Take into account the difference between Gregorian and Julian calendars
    my $gregorian_shift = int($year / 100) - int ($year / 400) - 2;
    
    $parts -= 492479 if $parts <= 0; # Floored division
    
    my $day = int($parts / 492480) + $gregorian_shift;
    
    $parts %= 492480;
    
    my $dow = ($year + int($year / 4) - $gregorian_shift + $day + 2) % 7;
    
    # Postponement rules
    if ($dow == 0 || $dow == 3 || $dow == 5) {
        $day++;
    } elsif ($dow == 1 && $parts >= 442111 && $r > 11) {
        $day++;
    } elsif ($dow == 2 && $parts >= 311676 && $r > 6) {
        $day += 2;
    }
    
    return DateTime->new(year => $year, month => 8, day => 31)->add( days => $day );
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
    
    return DateTime->new(year => $year, month => 3, day => 22)->add( days => $r );
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
    
    # Some holidays are not observed by Orthodox church
    $is_western = 1 if ($delta == $christian_holidays{'Corpus Christi'} ||
                        $delta == $christian_holidays{'Mardi Gras'} ||
                        $delta == $christian_holidays{'Ash Wednesday'}) && !$is_western;
    
    my $dt = easter($year, $is_western);
    
    $dt->add( days => $delta );
    
    return ($dt, $is_western);
}

# Return the date of a moveable holiday (for example, fourth Thursday of November).
# $dow is from 1 (Monday) to 7 (Sunday). $week is from 1st to 5th.
# Use a negative $week to return the last day of week in the month.
sub moveable_holiday {
    my ($year, $month, $dow, $week) = @_;
    
    my $dt;
    
    if ($week <= 0) {
        $dt = DateTime->last_day_of_month(year => $year, month => $month);
        
        $dt->subtract( days => ($dt->dow() - $dow) % 7 );
    } else {
        $dt = DateTime->new(year => $year, month => $month, day => 1);
    
        $dt->add( days => ($week - 1) * 7 + ($dow - $dt->dow()) % 7 );
    
        return undef if $dt->weekday_of_month() != $week; # Assertion (self-check)
    }

    # The month has no such date (for example, there is no 5th Sunday in January 2015)
    return undef if $dt->month != $month;

    return undef if $dt->dow() != $dow; # Assertion (self-check)
    
    return $dt;
}

sub output_date {
    my $dt = shift;
    
    return unless $dt;
    
    return $dt->format_cldr('d MMMM');
}

my $christian_regex = join('|', keys %christian_holidays);
$christian_regex =~ s/ /\\s+/g;

my $other_regex = join('|', keys %moveable_holidays, keys %jewish_holidays);
$other_regex =~ s/ /\\s+/g;

my $holiday = qr/(?:
                     (?: (?<d>catholic | orthodox | protestant | western | eastern) \s+ )? (?<h> $christian_regex) |
                     (?<h> $other_regex | jewish\s+holidays | hebrew\s+holidays | programmer['s]* \s+ day )
                 )/ix;

# Handle statement
handle query_raw => sub {
    my $result;
    
    # Read the input
    return unless /^(?: $holiday \s+
                     ( (?:date) (?: \s+ (?<y> \d{4}) )? |
                       (?<y> \d{4}) (?: \s+ date)?
                     ) |
                     (?:date \s+ of| when \s+ is) \s+ $holiday (?: \s+ (?<y> \d{4}) )? |
                     (?<y> \d{4}) (?: \s+ date)? \s+ $holiday (?: \s+ date)?
                    )$/ix;
            
    my $year = defined $+{y} ? $+{y} : ((localtime)[5] + 1900);
    return if ($year < 1800 || $year > 2299);
    
    my $denomination = defined $+{d} ? lc $+{d} : '';
    
    my $operation = $+{h};
    $operation =~ s/(?:^|\s+)\K(?!of|de)(\w+)/\u\L$1/g; # title case; skip 'of' and 'de', don't capitalize 's in possessive case
    
    # Calculate the dates
    if (exists $jewish_holidays{$operation}) {
        $result = output_date(jewish_holiday($year, $jewish_holidays{$operation}));
        
    } elsif (exists $christian_holidays{$operation}) {
        # Find the most common Christianity branch in this country using Location API
        my $is_western = !exists $orthodox_countries{$loc->country_code};
        if ($denomination) {
            $is_western = $denomination ne 'orthodox' && $denomination ne 'eastern';
        }
        
        my $dt; # the is_western flag may be changed by the christian_holiday function
        ($dt, $is_western) = christian_holiday($year, $is_western, $christian_holidays{$operation});
        $result = output_date($dt);
        $operation .= $is_western ? ' (Western Christianity)' : ' (Orthodox Christianity)';
        
    } elsif (exists $moveable_holidays{$operation}) {
        my $expr = $moveable_holidays{$operation};
        my $expr_regex = qr/([A-Z]{2})?<(\d+) (\d+) (\d+)>/;
        
        if (($expr =~ tr/</</) > 1) { # Several countries
            while ($expr =~ /$expr_regex/g) {
                $result .= ', ' if $result;
                $result .= code2country($1) . ': ' . output_date(moveable_holiday($year, $2, $3, $4));
            }
        } elsif ($expr =~ $expr_regex) { # One country
            $result = output_date(moveable_holiday($year, $2, $3, $4));
            $operation .= ' (' . code2country($1) . ')' if $1;
        }
        return unless $result;
        
    } elsif ($operation eq 'Jewish Holidays' || $operation eq 'Hebrew Holidays') {
        $result =   'Purim: ' .         output_date(jewish_holiday($year, HOLIDAY_PURIM)) .
                  ', Passover: ' .      output_date(jewish_holiday($year, HOLIDAY_PASSOVER)) .
                  ', Shavuot: ' .       output_date(jewish_holiday($year, HOLIDAY_SHAVUOT)) .
                  ', Rosh Hashanah: ' . output_date(jewish_holiday($year, HOLIDAY_ROSH_HASHANAH)) .
                  ', Yom Kippur: ' .    output_date(jewish_holiday($year, HOLIDAY_YOM_KIPPUR)) .
                  ', Sukkot: ' .        output_date(jewish_holiday($year, HOLIDAY_SUKKOT)) .
                  ', Hanukkah: ' .      output_date(jewish_holiday($year, HOLIDAY_HANUKKAH));
        
    } elsif ($operation eq 'Programmers\' Day' || $operation eq 'Programmer\'s Day' || $operation eq 'Programmer Day') {
        # https://en.wikipedia.org/wiki/Programmers%27_Day
        $result = output_date(DateTime->from_day_of_year(year => $year, day_of_year => 256));
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
