package DDG::Goodie::IsAwesome::flippingtables;
# ABSTRACT: Calculates the number of days in a given month

use DDG::Goodie;
use Switch;
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
triggers start => 'how many days are in', 'days in', 'number of days in', 'days';


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
    switch($month){
        case("january") {$i =     1;}
        case("february") {$i =    2;}
        case("march") {$i =       3;}
        case("april") {$i =       4;}
        case("may") {$i =         5;}
        case("june") {$i =        6;}
        case("july") {$i =        7;}
        case("august") {$i =      8;}
        case("september") {$i =   9;}
        case("october") {$i =     10;}
        case("november") {$i =    11;}
        case("december") {$i =    12;}
        else    { $i = -1; }
    }
    if ($i != -1){
        return calculateNumberOfDays($i);
    } else {
        return -1;
    }
}
1;