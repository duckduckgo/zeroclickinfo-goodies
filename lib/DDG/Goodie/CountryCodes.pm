package DDG::Goodie::CountryCodes;
# ABSTRACT: Matches country names to ISO 3166 codes and vice versa

use DDG::Goodie;
use Locale::Country qw/country2code code2country/;

use constant WPHREF => "https://en.wikipedia.org/wiki/ISO_3166-1";
    
zci answer_type => "country_codes";
zci is_cached   => 1;

name        "CountryCodes";
description "Matches country names to ISO 3166 codes";
source       WPHREF;
code_url    "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/CountryCodes.pm";
category    "geography";
topics      "travel", "geography";

primary_example_queries   "country code Japan", "iso code for Spain";
secondary_example_queries "Russia two letter country code", "3 letter country code of China";

attribution github  => ["killerfish", "Usman Raza"],
            twitter => ["f1shie", "Usman Raza"];

triggers any => 'country code','iso code','iso 3166';

# Adding alias for country names not present in Local::Country
Locale::Country::add_country_alias('Antigua and Barbuda'  => 'Antigua');
Locale::Country::add_country_alias('Antigua and Barbuda'  => 'Barbuda');
Locale::Country::add_country_alias('Russian Federation'   => 'Russia');
Locale::Country::add_country_alias('Trinidad and Tobago'  => 'Tobago');
Locale::Country::add_country_alias('Trinidad and Tobago'  => 'Trinidad');
Locale::Country::add_country_alias('United States'        => 'America');
Locale::Country::add_country_alias('Vatican City'         => 'Vatican');
Locale::Country::add_country_alias('Virgin Islands, U.S.' => 'US Virgin Islands');

handle remainder => sub {
    my ($query, $expr);

    # For user queries like 3 letter country code of China, two letter iso code japan
    if(/^((?:(2|3|two|three)\sletter)|numerical)?\s*(?:of|for)?\s*(\S+(?:\s+\S+)*)$/) {

        # Get the user entered country name or code e.g China, japan
        $query = $3;
        
        # Get any code set indication if present e.g. 3, two
        $expr = ($1 ? ($1 eq 'numerical' ? $1 : $2) : '2');
    }

    # For user queries like Russia numerical country code, fr country code
    if(/^(\S+(?:\s+\S+)*)\s((?:(2|3|two|three)\sletter)|numerical)?$/) {

        # Get the user entered country name or code e.g Russia, fr
        $query = $1;

        # Get any code set indication if present e.g. numerical, n/a (defaults to 2)
        $expr = ($2 ? ($2 eq 'numerical' ? $2 : $3) : '2');
    }
    
    return unless $query;

    my @answer;
    
    # Determine codeset and fetch result according to indicated codeset
    if($expr eq '2' || $expr eq 'two') {
        @answer = result($query, "alpha-2");
    }
 
    if($expr eq '3' || $expr eq 'three') {
        @answer = result($query, "alpha-3");
    }
    
    if($expr eq 'numerical') {
        @answer = result($query, "numeric");
    }
    
    # Return if user input was neither country or code
    return if @answer < 2;

    # Swap country and code, if user had entered code
    ($query, $answer[0]) = ($answer[0], $query) if $answer[1] eq 'code';
    
    
    my $text = sprintf qq(ISO 3166: %s - %s), ucfirst $query, $answer[0],
    my $html = sprintf '<a href="%s">ISO 3166</a>: ' . html_enc(ucfirst $query . ' - ' . $answer[0]), WPHREF;
    return $text, html => $html;
 
};

sub result {
    my ($query, $sw) = @_;
    my $result;
    
    # Validate user input and return result accordingly, possible values country, code, or invalid
    ($result = country2code($query, $sw)) ? return ($result, 'country') : ($result = code2country($query, $sw)) ? return ($result, 'code') : return -1;
}

1;
