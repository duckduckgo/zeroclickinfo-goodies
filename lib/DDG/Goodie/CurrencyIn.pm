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

use strict;
use DDG::Goodie;
use Locale::SubCountry;
use Text::Trim;
use Encode;

zci is_cached => 1;
zci answer_type => "currency_in";

primary_example_queries 'currency in australia';
secondary_example_queries 'currency in AU';
description 'find the official currency of a country';
name 'CurrencyIn';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CurrencyIn.pm';
category 'facts';
topics 'travel';
attribution github => ['https://github.com/Alchymista', 'Alchymista'],
            github => ['https://github.com/ozdemirburak', 'Burak Özdemir'];

triggers any => 'currency', 'currencies';    # User typed currency...

# Countries are lowercased but input from user, too ... so those always match...
# ...country is capitalized on output...

my %countries = share('currency.txt')->slurp;

sub clear_country_name {
    my $txt = shift;
    $txt =~ s/^\?$|\?$//g;      # Query may end with "?". If so take it away.
    return trim $txt;
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
            my @currencies =  split(',', decode("utf8", $string_currency)); # Split currencies into array

            my $count = $#currencies + 1;                       # Get number of currencies
            my $output_country = $country;                      # Pass country name to the output_country
            $output_country =~ s/\b(\w)/\U$1/g;                 # so it can by capitalized

            if($count eq 1) {
                chomp @currencies;
                return @currencies, structured_answer => {
                    input     => [html_enc($output_country)],
                    operation => "Currency in",
                    result    => @currencies
                };
            } else {
                my %data = ();

                for(@currencies) {
                    chomp $_;
                    if($_ =~ s/\((\w+)\)//) {
                        trim($_);
                        $data{$1} = $_; # Exclude the currency shortcode where stored between parantheses and assign it as a key
                    } else {
                        trim($_);
                        $data{"Non ISO 4217"} = $_; # See: https://en.wikipedia.org/wiki/ISO_4217
                    }
                }

                return \%data, structured_answer => {
                    id => "currency_in",
                    name => "CurrencyIn",
                    templates => {
                        group => 'list',
                        options => {
                            content => 'record',
                            moreAt => 0
                        }
                    },
                    data => {
                        title => "Currencies in $output_country",
                        record_data => \%data
                    }
                };
            }
        }
    }

    return;
};

1;

