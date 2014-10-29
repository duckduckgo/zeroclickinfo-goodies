package DDG::Goodie::CurrencyIn;
# ABSTRACT: Return currency type(s) in given country

# TODO: At the moment it return value only if user inputs the whole country name...
#     ...if user types "Salvador" instead of "El Salvador" then no results...
# TODO: think about how often currency in countries changes?
#     Parser (for Wikipedia) is included in share directory...

# In some countries there are more than one currency.
# For that reason values in hash are stored as arrays. (loaded from .txt as comma separated values )
# Example: %countries( "Zimbabwe"=>["A","B"], "Slovakia"=>["A"], ... )"

# Working examples for queries:
# What currency do I need in Egypt ?
# What currency will I need for Zimbabwe
# What is the currency used in Slovakia
# currency in Russia
# What type of currency do I need for Russia?

use DDG::Goodie;
use Locale::SubCountry;

zci is_cached => 1;
zci answer_type => "currency_in";

primary_example_queries 'currency in australia';
secondary_example_queries 'currency in AU';
description 'find the official currency of a country';
name 'CurrencyIn';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CurrencyIn.pm';
category 'facts';
topics 'travel';
attribution github => ['http://github.com/Alchymista', 'Alchymista'];

triggers any => 'currency', 'currencies';    # User typed currency...

# Countries are lowercased but input from user, too ... so those always match...
# ...country is capitalized on output...

my %countries = share('currency.txt')->slurp;

sub clear_country_name {
    my $txt = shift;
    $txt =~ s/^\?$|\?$//g;      # Query may end with "?". If so take it away.
    $txt =~ s/^\s+|\s+$//g;     # Trim spaces before and after the country name
    $txt;
}

handle remainder => sub {

    if (/^.*(?:in|of|for)(?:\sthe)?\s(.*?)$/i) {
        my $country = clear_country_name(lc($1));               # Clear country name - white spaces, question mark..

        # handle two-letter country codes
        if ( $country =~ /^[a-z]{2}$/i ) {
            my $loc;
            eval { $loc = Locale::SubCountry->new(uc($country)) };
            return if $@ || !$loc;
            $country = lc($loc->country);
        }

        if (exists $countries{$country."\n"}){
            my $string_currency = $countries{$country."\n"};    # Load currencies as string (one line from .txt)
            my @currencies =  split(',', $string_currency);     # Split currencies into array

            my $count = $#currencies + 1;                       # Get number of currencies
            my $output_country = $country;                      # Pass country name to the output_country
            $output_country =~ s/\b(\w)/\U$1/g;                 # so it can by capitalized

            my $result = $count == 1 ? "The currency in $output_country is the " : "Currencies in $output_country are: \n";

            # Append result with all currencies
            for (@currencies) {
                chomp;
                $result .= "$_\n";
            }

            chomp $result;
            my $html = $result;
            $html =~ s|\n|<br/>|g;

            return $result, html=>$html;
        }
    }

    return;
};

1;

