package DDG::Goodie::EasterDate;
# ABSTRACT: Show easter date for the specified year

use DDG::Goodie;
use Date::Easter;
use Date::Passover;

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
triggers any => 'easter', 'passover', 'pesach', 'rosh hashanah', 'jewish holidays';


my @month_names = qw(January February March April May June
    July August September October November December);

sub output_date {
    my ($month, $day) = @_;
    
    return "$day " . $month_names[$month - 1];
}

# Handle statement
handle query_raw => sub {
    my $result;
    
    # Read the input
    return unless /^(catholic\s+easter|orthodox\s+easter|protestant\s+easter|easter|
                     passover|pesach|rosh\s+hashanah|jewish\s+holidays)\s+
            (?:date |
             (?:date\s+)?(\d{4}) |
             (\d{4})(?:\s+date)?
            )$/ix;
            
    my $year = defined $2 ? $2 : (defined $3 ? $3 : (localtime)[5] + 1900);
    my $operation = $1;
    $operation =~ s/(\w+)/\u\L$1/g; # title case
    
    # Calculate the dates
    if ($operation eq 'Easter') {
        $result = 'Western: ' . output_date(easter($year)) . ', Orthodox: ' . output_date(orthodox_easter($year));
        
    } elsif ($operation eq 'Catholic Easter' || $operation eq 'Protestant Easter') {
        $result = output_date(easter($year));
        
    } elsif ($operation eq 'Orthodox Easter') {
        $result = output_date(orthodox_easter($year));
        
    } elsif ($operation eq 'Passover' || $operation eq 'Pesach') {
        $result = output_date(passover($year));
        
    } elsif ($operation eq 'Rosh Hashanah') {
        $result = output_date(roshhashanah($year));
        
    } elsif ($operation eq 'Jewish Holidays') {
        $result = 'Rosh Hashanah: ' . output_date(roshhashanah($year)) . ', Passover: ' . output_date(passover($year));
        
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
