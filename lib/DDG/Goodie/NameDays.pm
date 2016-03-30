package DDG::Goodie::NameDays;
# ABSTRACT: Display Name Days for a given name or date

use utf8;
use strict;
use warnings;
use DateTime;
use Locale::Country;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

my $date_parser = date_parser();

zci answer_type => "name_days";
zci is_cached   => 1;

# Triggers
triggers any => "name day", "name days", "nameday", "namedays", "imieniny",
                "jmeniny", "svátek"; # The phrase "name days" in Polish and Czech language



# Load the data file
my @names = share('preprocessed_names.txt')->slurp(iomode => '<:encoding(UTF-8)', chomp => 1); # Names indexed by day
my %dates = share('preprocessed_dates.txt')->slurp(iomode => '<:encoding(UTF-8)', chomp => 1); # Days indexed by name


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

    return $date_parser->parse_datestring_to_date($_);
}

sub get_flag {
    my $country = shift;
    return '<span class="flag-sm flag-sm-' . country2code($country) . '"></span>';
}

# Handle statement
handle remainder => sub {
    my $text;
    my $html;
    my $query;
    my $header;

    if (exists $dates{lc($_)}) {
        # Search by name first
        $query = ucfirst($_);
        ($text, $html) = split('\|', $dates{lc($_)});
        $header = 'Name days for <b>' . html_enc($query) . '</b>';
    } else {
        # Then, search by date
        my $day = $date_parser->parse_datestring_to_date($_);

        if (!$day) {
            $day = parse_other_date_formats($_);
        }

        return unless $day;

        # Any leap year here, because the array includes February, 29
        $day->set_year(2000);

        my $suffix = 'th';
        my $daynum = $day->day();
        $suffix = 'st' if $daynum == 1 || $daynum == 21 || $daynum == 31;
        $suffix = 'nd' if $daynum == 2 || $daynum == 22;
        $suffix = 'rd' if $daynum == 3 || $daynum == 23;
        $query = $day->month_name() . " $daynum$suffix";
        $text = $names[$day->day_of_year() - 1];

        # Convert to HTML
        $html = $text;
        $html =~ s/(\d{1,2}) (\w{1,3})/$1&nbsp;$2/g;
        $html =~ s@(.*?): (.*?)(?:$|; )@'<tr><td class="name-days-country">' . get_flag($1) .
                                        ' <span class="name-days-country-name">' . $1 . '</span>' .
                                        '</td><td class="name-days-dates">'  . $2 . '</td></tr>'@ge;

        $header = 'Name days on <b>' . html_enc($query) . '</b>';
    }

    # Add the header
    $html = '<div class="zci--name_days">' .
        '<span>' . $header . '</span>' .
        '<div class="zci__content"><table>' .
        $html . '</table></div></div>';

    return $text, html => $html;
};

1;
