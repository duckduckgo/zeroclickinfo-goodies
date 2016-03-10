package DDG::Goodie::IndependenceDay;
# ABSTRACT: Goodie answer for different countries' national independence days

use strict;
use DDG::Goodie;
use JSON::MaybeXS;
use utf8;
use Locale::Country;

zci answer_type => "independence_day";
zci is_cached   => 1;

# Triggers
triggers any => "independence day", "day of independence";


# uses https://en.wikipedia.org/wiki/List_of_national_independence_days as data source
my $data = share('independence_days.json')->slurp;
$data = decode_json($data);


# define aliases for some countries to improve hit rate
my $alias_lookup = share('country_aliases.json')->slurp;
$alias_lookup = decode_json($alias_lookup);


# Handle statement
handle query_clean => sub {

    # delete noise from query string
    s/(national|independence of|independence|day of|day|when|what|is the|for|)//g;
    # delete the whitespace left from query noise (spaces between words)
    s/^\s*|\s*$//g;
    # only the name of the country should be left in the string at this point


    # convert a possible alias into the proper name
    my $country_key = $alias_lookup->{$_} || $_;


    # return if the string is not one of the countries
    return unless $data->{$country_key};


    # Format the country name properly for display
    my $country = $country_key;
    # Title Case The Country Name
    $country =~ s/(\w\S*)/\u\L$1/g;
    # lowercase the words 'of', 'the' and 'and'
    $country =~ s/\sThe\s/ the /;
    $country =~ s/\sOf\s/ of /;
    $country =~ s/\sAnd\s/ and /;


    # ouput string formatting
    my $prolog = 'Independence Day of ' . $country;
    # date and year of independence
    my $date_str = $data->{$country_key}[0]{'date'} . ', ' . $data->{$country_key}[0]{'year'};
    # Some coutries have two dates, add it to the answer if a second one exists.
    if ($data->{$country_key}[1]){
        $date_str .= ' and ' . $data->{$country_key}[1]{'date'} . ', ' . $data->{$country_key}[1]{'year'};
    }



    my $text = $prolog  . ' ' . $date_str;

    return $text,
      structured_answer => {
        id => 'independence_day',
        templates => {
            group => "icon",
            item => 0,
            variants => {
              iconTitle => 'large',
              iconImage => 'large'
            }
        },
        data => {
            country_code => country2code($country_key),
            title => $date_str,
            subtitle => $prolog
        }
      };

};

1;
