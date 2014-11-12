package DDG::Goodie::NameDays;
# ABSTRACT: Display Name Days for a given name or date

use strict;
use DateTime;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

zci answer_type => "name_days_w25";
zci is_cached   => 1;

# Metadata
name "Name Days";
source "https://en.wikipedia.org/wiki/Name_days_in_Poland";
description "Name Days for a given name or date";
primary_example_queries "name day Maria", "1 June name day";
secondary_example_queries "name days today";
category "dates";
topics "social", "everyday";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/NameDays/W25/W25.pm";
attribution github => ["http://github.com/W25", "W25"];

# Triggers
triggers any => "name day", "name days", "nameday", "namedays", "imieniny";

# Load the data file
my @names = share('Poland.txt')->slurp(iomode => '<:encoding(UTF-8)'); # Names indexed by day
my %dates = (); # Days indexed by name

# File format: 366 lines (one for each day of a year).
# Each line contains names separated with a space.
# A line may contain the names in genitive case or variations of a name.
# These variations are placed after vertical bar character (|); they are
# not shown when searching for this day, but you can search for them.

sub load_days {
    my $day_of_year = 1;

    # Read names for each day and add them to the hash
    for (@names) {
        # Add all names, including the names after vertical bar
        my $names_for_date = $_;
        $names_for_date =~ s/\|/ /;
        for my $name (split(' ', $names_for_date)) {
            push(@{$dates{$name}}, $day_of_year);
        }
    
        # Remove the names after vertical bar (|)
        chomp;
        s/\s*\|.*$//;
        
        # Convert the first letter to uppercase
        s/\b(\w)/\u\L$1/g;
        
        # Advance to the next day
        $day_of_year++;
    }
    
    # Convert the dates to string
    for (keys %dates) {
        # Find all dates corresponding to this name
        my @ret = ();
        foreach (@{$dates{$_}}) {
            # Any leap year here, because the text file includes February, 29
            my $d = DateTime->from_day_of_year(year => 2000, day_of_year => $_);
            push(@ret, $d->strftime('%e %b'));
        }
        $dates{$_} = join(', ', @ret);
    }
}

load_days();

# Handle statement
handle remainder => sub {
    if (exists $dates{lc($_)}) {
        return $dates{lc($_)};
    }
    
    my $day = parse_datestring_to_date($_);
    
    return unless $day;
    
    $day->set_year(2000); # Any leap year here
    
    return $names[$day->day_of_year() - 1];
};

1;
