package DDG::Goodie::Zodiac;
#ABSTRACT : Find the Zodiac Sign by feeding Date as Input

use DDG::Goodie;

#My Imports
use strict;
use warnings;

#Import the Date::Horoscope Module
use Date::Horoscope;

#Import the Date::Manip Module
use Date::Manip qw(ParseDate);

zci answer_type => "zodiac";

triggers startend => "zodiac","zodiac sign","starsign","star sign";

#File MetaData
primary_example_queries "zodiac 21st June";
secondary_example_queries "31 Dec starsign","1st Jan 1981 star sign","zodiac sign 1 Nov";
description "Find the Zodiac Sign for the Respective Date given as Input based on Tropical Zodiac(2011) Source : https://en.wikipedia.org/wiki/Zodiac";
name "zodiac";
category "special";
topics "science";
attribution email => 'nomady@zoho.com',
            github => ['https://github.com/n0mady','NOMADY'];

handle remainder => sub {

                    #User Entered Date/Query
                    my $query=$_;

                    #Check if the User Provided Date is Valid
                    my $datevalid=&ParseDate($query);

                    #return if the given date is invalid
                    if(not $datevalid){return};

                    my $zodiacdate=Date::Horoscope::locate($query);

                    #Return Nothing if the User Provided Date is Invalid
                    return if $zodiacdate eq "";

                   #Return the Star Sign
                   $zodiacdate=ucfirst($zodiacdate);
                   return "Star Sign : $zodiacdate";
};

1;

