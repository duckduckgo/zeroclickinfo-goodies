package DDG::Goodie::NationalAnthems;
# ABSTRACT: Anthems

use DDG::Goodie;
use LWP::Simple qw(get);

zci answer_type => "national_anthems";
zci is_cached   => 1;

name "NationalAnthems";
source "http://www.flagdom.com/flag-resources/national-anthems/";
icon_url "http://www.flagdom.com/images/favicon.ico";
description "Displays the national anthem of a country";
primary_example_queries "national anthem of Brazil", "Canada National Anthem";
category "facts";
topics "special_interest";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/NationalAnthems.pm";
attribution github => ["https://github.com/kfloey", "Kevin Foley"];

triggers any => "national anthem";

my @countries = (
    "Afghanistan",
    "Albania",
    "Algeria",
    "Angola",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bolivia",
    "Botswana",
    "Brazil",
    "Brunei",
    "Bulgaria",
    "Burkina-Faso",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Cape Verde",
    "Central African Republic",
    "Chile",
    "China",
    "Colombia",
    "Comoros",
    "Congo, Democratic Republic",
    "Cook Islands",
    "Costa Rica",
    "Cote d Ivoire",
    "Croatia",
    "Cuba",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "East Timor",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Eritrea",
    "Estonia",
    "Ethiopia",
    "European Union",
    "Fiji",
    "Finland",
    "France",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Greece",
    "Guatemala",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kosovo",
    "Kuwait",
    "Kyrgyzstan",
    "Laos",
    "Latvia",
    "Lebanon",
    "Liberia",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macedonia",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Malta",
    "Marshall Islands",
    "Mauritania",
    "Mauritius",
    "Mexico",
    "Moldova",
    "Monaco",
    "Montenegro",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nepal",
    "Netherlands",
    "Netherlands Antilles",
    "New Zealand",
    "Nicaragua",
    "Nigeria",
    "Northern Mariana Islands",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Panama",
    "Papau New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Romania",
    "Russia",
    "Rwanda",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "South Africa",
    "South Korea",
    "Spain",
    "Sri Lanka",
    "St. Kitt's and Nevis",
    "Sudan",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syria",
    "Tanzania",
    "Thailand",
    "Togo",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Vatican City",
    "Venezuela",
    "Vietnam",
    "Virgin Islands",
    "Yemen"
                );

handle remainder => sub {
    my $country = "";
    foreach my $line ( @countries )
    {
        if (index(lc $_ ,lc $line) != -1) {
           $country = lc $line;
        } 
    }
    $country =~ s/ /_/g;
    if ($country eq "")
    {
        return;
    }
    else
    {
        my $page = get "http://www.flagdom.com/flag-resources/national-anthems/$country.html";
        my $lnum = (index(lc $page, "lyrics"));
        my $start = (index($page, "<p>", $lnum));
        my $end = (index($page,"</td>",$start));
        my $answer = substr($page, $start, $end - length($page));
        return html => ($answer . "<p></p><p><a href='http://www.flagdom.com/flag-resources/national-anthems/'>Flagdom</a></p>");
    }

};

1;
