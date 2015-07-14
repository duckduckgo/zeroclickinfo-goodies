package DDG::Goodie::LeapYear;
# ABSTRACT: Check if a year is leap year

use strict;
use DDG::Goodie;
use Date::Leapyear;

zci answer_type => "leap_year";

primary_example_queries 'is it a leap year';
secondary_example_queries 'when were the last 50 leap years';
description 'Check if it is a leap year';
name 'Leap year';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/LeapYear.pm';
category 'dates';
topics 'everyday';
attribution github => [ 'https://github.com/tophattedcoder', 'Tom Bebbington'],
            twitter => ['@tophattedcoder', 'Tom Bebbington'],
            github => ['https://github.com/Sloff', 'Sloff'];

zci is_cached => 1;
triggers startend => 'leap years', 'leap year';
# 'is' in tenses
my %is_tense = (
    past => 'was',
    present => 'is',
    future => 'will be',
);
# 'is not' in tenses
my %is_not_tense = (
    past => 'was not',
    present => 'is not',
    future => 'will not be',
);

# searches for leap years
sub search_leaps {
    my ($num, $direction, $include_curr, $curryear) = @_;
    my $cyear = $curryear;
    my @years = ();
    if($include_curr == 0) {
        $cyear += $direction;
    }
    while($#years + 1 < $num) {
        while(!isleap($cyear)) {
            $cyear += $direction;
        }
        push @years, ($cyear);
        $cyear += $direction;
    }
    return @years;
}
# finds the matching tense for the given year
sub find_tense {
    my ($cyear, $year) = @_;
    if($cyear < $year) {
        return "past";
    } elsif($cyear > $year) {
        return "future";
    } else {
        return "present";
    }
}
# formats the year from an integer
sub format_year {
    my ($cyear) = @_;
    if(!defined($cyear)) {
        $cyear = $_;
    }
    if($cyear < 0) {
        $cyear = abs($cyear);
        return "$cyear BCE";
    } else {
        return "$cyear CE";
    }
}
handle remainder => sub {
    
    my $year = (localtime)[5] + 1900;
    my ($plaintext, $title, $subtitle);
    
    if ($_ =~ /(last|previous) ([0-9][0-9]?)$/i) {
        my @years = search_leaps($2, -1, 0, $year);
        @years = map(format_year, @years);
        my $pretty_years = join(', ', @years);
        
        $plaintext = "The last $2 leap years were $pretty_years";
        $title = $pretty_years;
        $subtitle = "The last $2 leap years";
        
    } elsif ($_ =~ /(next|future) ([0-9][0-9]?)$/i) {
        my @years = search_leaps($2, 1, 0, $year);
        @years = map(format_year, @years);
        my $pretty_years = join(', ', @years);
        
        $plaintext = "The $1 $2 leap years will be $pretty_years";
        $title = $pretty_years;
        $subtitle = "The $1 $2 leap years";
        
    } elsif ($_ =~ /^(after|before) ([0-9]+) ?(ad|bce|bc|ce)?$/) {
        my $cyear = $2;
        my $direction = $1;
        if(defined($3) && $3 =~ /^(bce|bc)$/i) {
            $cyear = -$cyear;
        }
        my $dir = 1;
        if($direction eq "before") {
            $dir = -1;
        }
        my @years = search_leaps(5, $dir, 0, $cyear);
        @years = map(format_year, @years);
        my $pretty_years = join(', ', @years);
        my $pretty_year = format_year($cyear);
        
        $plaintext = "The 5 leap years $direction $pretty_year are $pretty_years";
        $title = $pretty_years;
        $subtitle = "The 5 leap years $direction $pretty_year";
        
    } elsif ($_ =~ /(next|future|upcoming)$/i) {
        my ($nyear) = search_leaps(1, 1, 0, $year);
        $nyear = format_year($nyear);
        
        $plaintext = "$nyear will be the $1 leap year";
        $title = $nyear;
        $subtitle = "The $1 leap year";
        
    } elsif ($_ =~ /(latest|last|previous)$/i) {
        my ($pyear) = search_leaps(1, -1, 0, $year);
        $pyear = format_year($pyear);
        
        $plaintext = "$pyear was the $1 leap year";
        $title = $pyear;
        $subtitle = "The $1 leap year";
        
    } elsif ($_ =~ /(most recent)$/i) {
        my ($ryear) = search_leaps(1, -1, 1, $year);
        $ryear = format_year($ryear);
        
        $plaintext = "$ryear is the $1 leap year";
        $title = $ryear;
        $subtitle = "The $1 leap year";
        
    } elsif($_ =~ /^(was|is|will) ([0-9]+) ?(ad|bce|bc|ce)?( be)? a$/i) {
        my $cyear = $2;
        if(defined($3) && $3 =~ /^(bce|bc)$/i) {
            $cyear = -$cyear;
        }
        my $fyear = format_year($cyear);
        my $tense = find_tense($cyear, $year);
        if(isleap($cyear)) {
            
            $plaintext = "Yes! $fyear $is_tense{$tense} a leap year";
            
        } else {
        
            $plaintext = "No. $fyear $is_not_tense{$tense} a leap year"
            
        }
    } elsif($_ =~ /^is it( now | currently)? a|are we in a$/i) {
        my $fyear = format_year($year);
        if(isleap($year)) {
            
            $plaintext = "Yes! $fyear is a leap year";
            
        } else {
            
            $plaintext = "No. $fyear is not a leap year",
            
        }
    }
    
    return $plaintext,
    structured_answer => {
        id => "leap_year",
        name => "Answer",
        data => {
            title => $title || $plaintext,
            subtitle => $subtitle
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    }
};

1;
