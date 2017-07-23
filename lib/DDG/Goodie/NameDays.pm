package DDG::Goodie::NameDays;
# ABSTRACT: Display Name Days for a given name or date

use utf8;
use strict;
use warnings;
use DateTime;
use Locale::Country;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

zci answer_type => "name_days";
zci is_cached   => 1;

# Triggers
triggers any => "name day", "name days", "nameday", "namedays", "imieniny",
                "jmeniny", "svátek"; # The phrase "name days" in Polish and Czech language



# Load the data file
my @names = share('preprocessed_names.txt')->slurp(iomode => '<:encoding(UTF-8)', chomp => 1); # Names indexed by day
my %dates = share('preprocessed_dates.txt')->slurp(iomode => '<:encoding(UTF-8)', chomp => 1); # Days indexed by name

# trim and remove extra spaces
sub  clean { my $s = shift; $s =~ s/^\s+|\s+$//g; $s =~ s/\s+/ /g; return $s };

sub parse_other_date_formats {
    # Quick fix for the date formats not supported by parse_datestring_to_date.
    # If parse_datestring_to_date will be improved, you can remove some of the following code.

    # US date format ("month/day")
    if (/^([0-1]?[0-9])\s?\/\s?([0-3]?[0-9])$/) {
        # Suppress errors for invalid dates with eval
        return eval { new DateTime(year => 2000, day => $2, month => $1) };
    }

    # Polish date format ("day.month")
    if (/^([0-3]?[0-9])\s?\.\s?([0-1]?[0-9])$/) {
        return eval { new DateTime(year => 2000, day => $1, month => $2) };
    }

    # Polish month names
    s/\b(styczeń|stycznia)\b/Jan/i;
    s/\b(luty|lutego)\b/Feb/i;
    s/\b(marzec|marca)\b/Mar/i;
    s/\b(kwiecień|kwietnia)\b/Apr/i;
    s/\b(maj|maja)\b/May/i;
    s/\b(czerwiec|czerwca)\b/Jun/i;
    s/\b(lipiec|lipca)\b/Jul/i;
    s/\b(sierpień|sierpnia)\b/Aug/i;
    s/\b(wrzesień|września)\b/Sep/i;
    s/\b(październik|października)\b/Oct/i;
    s/\b(listopad|listopada)\b/Nov/i;
    s/\b(grudzień|grudnia)\b/Dec/i;

    # Czech month names
    s/\b(leden|ledna)\b/Jan/i;
    s/\b(únor|února)\b/Feb/i;
    s/\b(březen|března)\b/Mar/i;
    s/\b(duben|dubna)\b/Apr/i;
    s/\b(květen|května)\b/May/i;
    s/\b(červen|června)\b/Jun/i;
    s/\b(červenec|července)\b/Jul/i;
    s/\b(srpen|srpna)\b/Aug/i;
    s/\b(září)\b/Sep/i;
    s/\b(říjen|října)\b/Oct/i;
    s/\b(listopad|listopadu)\b/Nov/i;
    s/\b(prosinec|prosince)\b/Dec/i;

    # Parse_datestring_to_date uses the current year if the year is not specified, so
    # it will not parse "29 Feb" in a non-leap year. Fix this problem here.
    if (/^29\s?(?:th)?\s*(Feb|February)/ || /(Feb|February)\s*29\s?(?:th)?$/) {
        return new DateTime(year => 2000, day => 29, month => 2);
    }

    return parse_datestring_to_date($_);
}

sub get_flag {
    my $country = shift;
    return country2code($country);
}

# Handle statement
handle remainder => sub {
    my $text;

    if (exists $dates{lc($_)}) {
        # Search by name first
        $text = $dates{lc($_)};
    } else {
        # Then, search by date
        my $day = parse_datestring_to_date($_);
        $day = parse_other_date_formats($_) unless $day;
        return unless $day;

        # Any leap year here, because the array includes February, 29
        $day->set_year(2000);
        $text = $names[$day->day_of_year() - 1];
    }

    # split string answer into name days by country
    my @name_days = split /;/, $text;
    my @sorted_days;
    foreach (@name_days) {
        # Break answer apart for each country
        my @day_parts = split /:/, $_;
        my $country_sorted = {};
        my @day_dates = split /,/, $day_parts[1];

        # Add country and flag
        $country_sorted->{country} = $day_parts[0];
        $country_sorted->{flag} = get_flag($day_parts[0]);

        my %months;
        foreach (@day_dates) {
            # Put days from same month into a hash
            my @day_and_month = split / /, clean($_);
            %months->{$day_and_month[1]} = [] unless exists %months->{$day_and_month[1]};
            push %months->{$day_and_month[1]}, $day_and_month[0];
        }

        my @sorted_months;
        foreach my $key (keys %months) {
            # Convert hash into a string
            my $sorted_month;
            foreach (%months->{$key}) {
                $sorted_month = join(', ', @{%months->{$key}});
            }
            $sorted_month = $key . ' ' . $sorted_month;
            push @sorted_months, $sorted_month;
        }

        # Sort each string in array chronologically
        sub by_month {
            my $mi = shift;
            my ($m1, $m2) = map { lc(substr $_, 0, 3) } @_;
            return $mi->{$m1} <=> $mi->{$m2};
        }
        my @mons = qw(jan feb mar apr may jun jul aug sep oct nov dec);
        my %mon_ind; @mon_ind{@mons} = 1..12;
        my @chronological_months = sort { by_month(\%mon_ind, $a, $b) } @sorted_months;
        $country_sorted->{months} = \@chronological_months;
        push @sorted_days, $country_sorted;
    }

    # Create and populate structured answer
    my $structured_answer = {};
    $structured_answer->{templates}->{group} = 'text';
    $structured_answer->{templates}->{options}->{content} = 'DDH.name_days.content';
    $structured_answer->{data}->{name_days} = \@sorted_days;
    $structured_answer->{data}->{name} = ucfirst($_);
    return clean($text), structured_answer => $structured_answer;
};

1;
