package DDG::Goodie::Zodiac;
#ABSTRACT : Find the Zodiac Sign by feeding Date as Input

use DDG::Goodie;

#My Imports
use strict;
use warnings;

#Import the Date Manipulation Module
use Date::Manip qw(ParseDate);							

#Import the DateTime::Event::Zodiac Module
use DateTime::Event::Zodiac qw(zodiac_date_name);

zci answer_type => "zodiac";

triggers startend => "zodiac","zodiac sign","starsign","star sign";

#File MetaData
primary_example_queries "zodiac 21st June";
secondary_example_queries "31 Dec starsign","1st Jan 1981 star sign","zodiac sign 1 Nov";
description	"Find the Zodiac Sign for the Respective Date given as Input based on Tropical Zodiac(2011) Source : https://en.wikipedia.org/wiki/Zodiac";
name "zodiac";
category "special";
topics "science";
attribution email => 'nomady@zoho.com',
	    github => ['https://github.com/n0mady','NOMADY'];
			
handle remainder => sub {
	
		#User Entered Date/Query
		my $query=$_;								
		
		#Temp Variable
		my $result;

		#Parse the Given Date String
		my $date=&ParseDate($query);
		
		#Return Nothing if the User Provided Date is Invalid	
		return if $date eq "";
	
		my $zodiacdate=DateTime->new(
		
			#Extract the Year from Date String
			year=>substr($date,0,4),

			#Extract the Month from Date String
			month=>substr($date,4,2),
		
			#Extract the Day from Date String
			day=>substr($date,6,2)		
		);					

		#Return the Star Sign
		$result = " Star Sign :",zodiac_date_name($zodiacdate);
		return $result,
			structured_answer => {
			input	=> [html_enc[$query]],
			operation => 'Star Sign'
			result	=> html_enc(zodiac_date_name($zodiacdate))
		};
		


};

1;

