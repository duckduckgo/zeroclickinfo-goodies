package DDG::Goodie::IsAwesome::flippingtables;
# ABSTRACT: Calculates the number of days in a given month

use DDG::Goodie;

zci answer_type => "days_in_month";
zci is_cached   => 1;

name "Number of days in a month";
description "Calculates the number of days in a month";
primary_example_queries "how many days are in january";
secondary_example_queries "days in february";
category "dates";
topics "math";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/flippingtables.pm";
attribution github => ["https://github.com/flippingtables", "flippingtables"];

# Triggers
triggers start => 'how many days are in', 'days in', 'number of days in', 'days', 'how many days are there in', 'the number of days in';


# Handle statement
handle remainder => sub {
    return unless $_; # Guard against "no answer"
    my $query = $_; 
    my $days = calculateNumberOfDaysForMonthString($query);
    if ($days != -1){
        return $days;
    } else {
        return;
    }
    
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
    my $month = $_[0];
    my $i;
    my %months = (
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

    $i = $months {lc $month} || -1;
    
    if ($i != -1){
        return calculateNumberOfDays($i);
    } else {
        return -1;
    }
}
1;