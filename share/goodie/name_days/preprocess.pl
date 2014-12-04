#!/usr/bin/perl
# Preprocess the source files and output data structures for slurping

use strict;
use DateTime;
use Path::Class;

# Load the data file
my @names = (); # Names indexed by day
my %dates = (); # Days indexed by name

# File format: 366 lines (one for each day of a year).
# Each line contains names separated with a space.
# A line may contain the names in genitive case or variations of a name.
# These variations are placed after vertical bar character (|); they are
# not shown when searching for this day, but you can search for them.

sub load_days_file {
    my $file_name = shift();
    
    my @lines = file($file_name)->slurp(iomode => '<:encoding(UTF-8)');
    
    $file_name =~ s/\.txt$//;
    $file_name =~ s/_/ /g;
    
    die "The text file must include 366 lines" unless scalar(@lines) == 366;

    my $day_of_year = 1;

    # Read names for each day and add them to the hash
    for (@lines) {
        # Add all names, including the names after vertical bar
        my $names_for_date = lc($_);
        $names_for_date =~ s/\|/ /;
        for my $name (split(' ', $names_for_date)) {
            push(@{$dates{$name}}, $file_name . '|' . $day_of_year);
        }
    
        # Remove the names after vertical bar (|)
        chomp;
        s/\s*\|.*$//;
        
        if ($_) {
            $names[$day_of_year - 1] .= "; " if ($names[$day_of_year - 1]);
            $names[$day_of_year - 1] .= $file_name . ': ' . $_;
        }
        
        # Advance to the next day
        $day_of_year++;
    }
}

sub finish_loading {
    # Convert the dates to string
    for (keys %dates) {
        # Group the dates by country
        my %dates_by_country = ();
        foreach (@{$dates{$_}}) {
            die 'Internal error' unless /^(.*?)\|(\d+)$/;
            # Any leap year here, because the text file includes February, 29
            my $d = DateTime->from_day_of_year(year => 2000, day_of_year => $2);
            if (exists $dates_by_country{$1}) {
                $dates_by_country{$1} .= ', ';
            }
            $dates_by_country{$1} .= $d->strftime('%e %b');
        }
        
        # Convert to string
        my $res = '';
        foreach (sort keys %dates_by_country) {
            $res .= $_ . ': ' . $dates_by_country{$_} . "; ";
        }
        
        $res =~ s/; $//;
        $dates{$_} = $res;
    }
}


# Load the source files into %dates and @names

load_days_file('Czech_Republic.txt');
load_days_file('Hungary.txt');
load_days_file('Poland.txt');
finish_loading();


# Output the array and the hash.
# Spew does not work for hashes, so use two loops here.

open(my $fd, '>:encoding(UTF-8)', 'preprocessed_dates.txt') or die;

for (keys %dates) {
    print($fd $_ . "\n" . $dates{$_} . "\n");
}


open(my $fn, '>:encoding(UTF-8)', 'preprocessed_names.txt') or die;

for (@names) {
    print($fn $_ . "\n");
}
