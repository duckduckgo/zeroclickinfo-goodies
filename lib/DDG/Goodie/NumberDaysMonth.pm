package DDG::Goodie::NumberDaysMonth;
# ABSTRACT: Returns number of days in a given month

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => 'number_days_month';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers any => 'how many days are in', 'what is the number of days in', 'number of days in';

# Handle statement
handle remainder => sub {
    my $remainder = $_;
	return unless $remainder =~ qr/^\s*\w+\s*$/;
	my ($month) = $remainder =~ qr/(\w+)/;
    my $days = calculateNumberOfDaysForMonthString($month);
	return if $days == -1;
	return "Number of days in $month is $days.",
    structured_answer => {
        input => [ucfirst $month],
        operation => 'Number of days in month',
        result => ($days)
    };
};

#Implemented the formula by Curtis Monroe
#Original reference is found here: http://cmcenroe.me/2014/12/05/days-in-month-formula.html
sub calculateNumberOfDays{
    my ($x) = @_;
    my $float = $x/8;
    my $roundedFirst = int($float + $float/($float*2));
    my $float2 = 1/$x;
    my $roundedSecond = int($float2);
    return (28 + ($x + $roundedFirst) % 2) + (2 % $x) + (2 * $roundedSecond);
}

sub calculateNumberOfDaysForMonthString{
    my $month = lc($_[0]);
	my %months;
	if(length $month == 3 && $month ne "may")
	{
		%months = (
        "jan" => 1,
        "feb" => 2,
        "mar" => 3,
        "apr" => 4,
        "may" => 5,
        "jun" => 6,
        "jul" => 7,
        "aug" => 8,
        "sep" => 9,
        "oct" => 10,
        "nov" => 11,
        "dec" => 12
		);
	}else{
		%months = (
        "january" =>     1,
        "february" =>    2,
        "march" =>       3,
        "april" =>       4,
        "may" =>         5,
        "june" =>        6,
        "july" =>        7,
        "august" =>      8,
        "september" =>   9,
        "october" =>     10,
        "november" =>    11,
        "december" =>    12
		);
	}
	return exists $months{$month} ? calculateNumberOfDays($months{$month}) : -1;
}

1;
