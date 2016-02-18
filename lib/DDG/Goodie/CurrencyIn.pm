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
use utf8;
use DDG::Goodie;
use Locale::SubCountry;
use Text::Trim;
use JSON::MaybeXS;

zci is_cached => 1;
zci answer_type => "currency_in";

triggers any => 'currency', 'currencies';

my $data = share('currencies.json')->slurp;
my $countries = decode_json($data);

sub clear_country_name {
    my $txt = shift;
    $txt =~ s/^\?$|\?$//g;  # Query may end with "?". If so take it away.
    return trim($txt);
}

handle remainder => sub {

    if (/^.*(?:in|of|for)(?:\sthe)?\s(.*?)$/i) {
        my $country = clear_country_name(lc($1));  # Clear country name - white spaces, question mark..

        # handle two-letter country codes
        if ($country =~ /^[a-z]{2}$/i) {
            my $loc;
            eval { $loc = Locale::SubCountry->new(uc($country)) };
            return if $@ || !$loc;
            $country = lc($loc->country);
        }

        return unless exists $countries->{$country};

        $country = $countries->{$country};
        my @currencies = @{$country->{"currencies"}};
        my $output_country = html_enc($country->{"ucwords"});

        if (scalar @currencies eq 1) {
            return $currencies[0]{"string"}, structured_answer => {
                input     => [$output_country],
                operation => "Currency in",
                result    => $currencies[0]{"string"}
            };
        } else {
            my %data = ();

            foreach my $key (keys @currencies) {
                $data{$currencies[$key]{"shortcode"}} = $currencies[$key]{"currency"};
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

    return;
};

1;

