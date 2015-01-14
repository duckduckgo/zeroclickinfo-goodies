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
triggers any => 'easter', 'passover', 'pesach', 'rosh hashana', 'rosh hashanah', 'yom kippur',
                'hanukkah', 'chanukkah', 'purim', 'shavuot', 'sukkot', 'jewish holidays',
                'hebrew holidays', 'holidays in israel';


my @month_names = qw(January February March April May June
    July August September October November December);

sub output_date {
    my ($month, $day) = @_;
    
    return "$day " . $month_names[$month - 1];
}

sub roshhashanah {
    # Gauss algorithm
	my $y = shift;
	
	my $r = (12 * $y + 12) % 19;

	my $parts = 765433 * $r - 1565 * $y - 445405 + 123120 * ($y % 4);
	
	my $gregorian_shift = int($y / 100) - int ($y / 400) - 2;
	
	$parts -= 492479 if $parts <= 0;
	
	my $day = int($parts / 492480) + $gregorian_shift;
	
	$parts %= 492480;
	
	my $dow = ($y + int($y / 4) - $gregorian_shift + $day + 2) % 7;
	
	if ($dow == 0 || $dow == 3 || $dow == 5) {
		$day++;
	} elsif ($dow == 1 && $parts >= 442111 && $r > 11) {
		$day++;
	} elsif ($dow == 2 && $parts >= 311676 && $r > 6) {
		$day += 2;
	}
	
	return (8, $day + 31) if $day <= 0;
	
	return (10, $day - 30) if $day > 30;
    
    return (9, $day);
}

sub passover {
	my $year = shift;
	my ($month, $day) = roshhashanah($year);
	
	my $dt = DateTime->new(year => $year, month => $month, day => $day);
	
	$dt->add( days => -163 );
	
	return ($dt->month, $dt->day);
}

sub yomkippur {
	my $year = shift;
	my ($month, $day) = roshhashanah($year);
	
	my $dt = DateTime->new(year => $year, month => $month, day => $day);
	
	$dt->add( days => 9 );
	
	return ($dt->month, $dt->day);
}

sub hanukkah {
	my $year = shift;
	my ($month, $day) = roshhashanah($year);
	
	my $dt = DateTime->new(year => $year, month => $month, day => $day);
    
    ($month, $day) = roshhashanah($year + 1);
    
    my $next = DateTime->new(year => $year + 1, month => $month, day => $day);
    
    my $year_length = $next->delta_days($dt)->delta_days();
    
    my $is_complete_year = $year_length == 355 || $year_length == 385;
	
	$dt->add( days => $is_complete_year ? 84 : 83 );
	
	return ($dt->month, $dt->day);
}

sub purim {
	my $year = shift;
	my ($month, $day) = roshhashanah($year);
	
	my $dt = DateTime->new(year => $year, month => $month, day => $day);
	
	$dt->add( days => -193 );
	
	return ($dt->month, $dt->day);
}

sub shavuot {
	my $year = shift;
	my ($month, $day) = roshhashanah($year);
	
	my $dt = DateTime->new(year => $year, month => $month, day => $day);
	
	$dt->add( days => -113 );
	
	return ($dt->month, $dt->day);
}

sub sukkot {
	my $year = shift;
	my ($month, $day) = roshhashanah($year);
	
	my $dt = DateTime->new(year => $year, month => $month, day => $day);
	
	$dt->add( days => 14 );
	
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

# Handle statement
handle query_raw => sub {
    my $result;
    
    # Read the input
    my $holiday = qr/(?<h>catholic\s+easter| orthodox\s+easter| protestant\s+easter| easter |
        passover| pesach| rosh\s+hashanah?| yom\s+kippur | chanukkah | hanukkah |
        shavuot | sukkot | purim | jewish\s+holidays | hebrew\s+holidays | holidays\s+in\s+israel)/ix;
    
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
        
    } elsif ($operation eq 'Passover' || $operation eq 'Pesach') {
        $result = output_date(passover($year));
        
    } elsif ($operation eq 'Rosh Hashanah' || $operation eq 'Rosh Hashana') {
        $result = output_date(roshhashanah($year));
    
    } elsif ($operation eq 'Yom Kippur') {
        $result = output_date(yomkippur($year));
        
    } elsif ($operation eq 'Hanukkah' || $operation eq 'Chanukkah') {
        $result = output_date(hanukkah($year));
        
    } elsif ($operation eq 'Purim') {
        $result = output_date(purim($year));
        
    } elsif ($operation eq 'Sukkot') {
        $result = output_date(sukkot($year));
    
    } elsif ($operation eq 'Shavuot') {
        $result = output_date(shavuot($year));
        
    } elsif ($operation eq 'Jewish Holidays') {
        $result = 'Purim: ' . output_date(purim($year)) .
                  ', Passover: ' . output_date(passover($year)) .
                  ', Shavuot: ' . output_date(shavuot($year)) .
                  ', Rosh Hashanah: ' . output_date(roshhashanah($year)) .
                  ', Yom Kippur: ' . output_date(yomkippur($year)) .
                  ', Sukkot: ' . output_date(sukkot($year)) .
                  ', Hanukkah: ' . output_date(hanukkah($year));
        
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
