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
            twitter     => ["f1shie", "Usman Raza"];

triggers any => 'country code','iso code','iso 3166';

Locale::Country::add_country_alias('Antigua and Barbuda'  => 'Antigua');
Locale::Country::add_country_alias('Antigua and Barbuda'  => 'Barbuda');
Locale::Country::add_country_alias('Russian Federation'   => 'Russia');
Locale::Country::add_country_alias('Trinidad and Tobago'  => 'Tobago');
Locale::Country::add_country_alias('Trinidad and Tobago'  => 'Trinidad');
Locale::Country::add_country_alias('Vatican City'         => 'Vatican');
Locale::Country::add_country_alias('Virgin Islands, U.S.' => 'US Virgin Islands');

handle remainder => sub {
    return unless /^([a-zA-Z]+)*\s*(((2|3|two|three)\sletter)|numerical)?$|^(((2|3|two|three)\sletter)|numerical)?\s*(?:of|for)?\s*([a-zA-Z]+)*$/;
    my (@answer, $expr);
    
    # Get the user input which could be a country or code like France or fra or fr
    my $query = $8;
    $query = $1 if $1;
    
    # Default to alpha-2 if user has not specified Codeset
    $expr = '2' unless $expr = ($4 || $7 || $2 || $5);

    if($expr && ($expr eq '2' || $expr eq 'two')) {
        @answer = result($query, "alpha-2");
    }
 
    if($expr && ($expr eq '3' || $expr eq 'three')) {
        @answer = result($query, "alpha-3");
    }
    
    if($expr && ($expr eq 'numerical')) {
        @answer = result($query, "numeric");
    }
    
    # Return if user input was neither country or code
    return if @answer < 2;

    # Swap country and code, if user had entered code
    ($query, $answer[0]) = ($answer[0], $query) if $answer[1] eq 'code';
    
    
    my $text = sprintf qq(ISO 3166: %s - %s), ucfirst $query, $answer[0],
    my $html = sprintf qq(<a href="%s">ISO 3166</a>: %s - %s), WPHREF, ucfirst $query, $answer[0];
    return $text, html => $html;
 
};

sub result {
    my ($query, $sw) = @_;
    my $result;
    
    # Validate user input and return result accordingly
    ($result = country2code($query, $sw)) ? return ($result, 'country') : ($result = code2country($query, $sw)) ? return ($result, 'code') : return -1;
}

1;
