package DDG::Goodie::Zodiac;
#ABSTRACT : Find the Zodiac Sign by feeding Date as Input

use DDG::Goodie;

#My Imports
use strict;
use warnings;
use Date::Manip qw(ParseDate Date_Cmp);							#Import the Date Manipulation Module

zci answer_type => "zodiac";
zci is_cached => 1;

#File MetaData
primary_example_queries 	"zodiac 21st June";
secondary_example_queries 	"31 Dec starsign",
						  	"1st Jan 1981 star sign";
description					"
							 Find the Zodiac Sign for the Respective Date given as Input 
							 based on Tropical Zodiac(2011)
			 
			 				 Source : https://en.wikipedia.org/wiki/Zodiac
							";
name						"zodiac";
category					"special";
topics						"science";
attribution					email		=> 'nomady@zoho.com',
							github 		=> ['https://github.com/n0mady','NOMADY'];
triggers					startend	=> "zodiac","starsign","star sign";
			
			 
handle remainder => sub {
		
		my $Query=$_;							#User Entered Date/Query
	
		my $Date=&ParseDate($Query);			#Parse the Given Date String

		my $Year=substr($Date,0,4);				#Extract the Year from the Date String for Further Comparison
	
		my $Star_Sign="";

		if($Date eq ""){return;} 				#Return Nothing if the User Provided Date is Invalid			

		#Define the Date Ranges for the Respective Star Signs
		my %Star_Sign_Dates=(
								"Aries-Start"		=> &ParseDate("21 March $Year"),
								"Aries-End"			=> &ParseDate("20 April $Year"),
								"Taurus-Start"		=> &ParseDate("21 April $Year"),
								"Taurus-End"		=> &ParseDate("21 May $Year"),
								"Gemini-Start"		=> &ParseDate("22 May $Year"),
								"Gemini-End"		=> &ParseDate("21 June $Year"),
								"Cancer-Start"		=> &ParseDate("22 June $Year"),
								"Cancer-End"		=> &ParseDate("22 July $Year"),
								"Leo-Start"			=> &ParseDate("23 July $Year"),
								"Leo-End"			=> &ParseDate("22 August $Year"),
								"Virgo-Start"		=> &ParseDate("23 August $Year"),
								"Virgo-End"			=> &ParseDate("23 September $Year"),
								"Libra-Start"		=> &ParseDate("24 September $Year"),
								"Libra-End"			=> &ParseDate("23 October $Year"),
								"Scorpio-Start"		=> &ParseDate("24 October $Year"),
								"Scorpio-End"		=> &ParseDate("22 November $Year"),
								"Sagittarius-Start"	=> &ParseDate("23 November $Year"),
								"Sagittarius-End"	=> &ParseDate("21 December $Year"),
								"Capricorn-Start"	=> &ParseDate("22 December $Year"),
								"Capricorn-End"		=> &ParseDate("20 January $Year"),
								"Aquarius-Start"	=> &ParseDate("21 January $Year"),
								"Aquarius-End"		=> &ParseDate("19 February $Year"),
								"Pisces-Start"		=> &ParseDate("20 February $Year"),
								"Pisces-End"		=> &ParseDate("20 March $Year"),
								"Year-Start"		=> &ParseDate("1 January $Year"),
								"Year-End"			=> &ParseDate("31 December $Year")
							);

		#Compare the Given Date with Every Other Star Sign Range and Emit Output

		if((&Date_Cmp($Date,$Star_Sign_Dates{"Aries-Start"})>=0)&&(&Date_Cmp($Star_Sign_Dates{"Aries-End"},$Date)>=0))
		{
			$Star_Sign="Aries";
		}
		elsif((&Date_Cmp($Date,$Star_Sign_Dates{"Taurus-Start"})>=0)&&(&Date_Cmp($Star_Sign_Dates{"Taurus-End"},$Date)>=0))
		{
			$Star_Sign="Taurus";
		}
		elsif((&Date_Cmp($Date,$Star_Sign_Dates{"Gemini-Start"})>=0)&&(&Date_Cmp($Star_Sign_Dates{"Gemini-End"},$Date)>=0))
		{
			$Star_Sign="Gemini";
		}
		elsif((&Date_Cmp($Date,$Star_Sign_Dates{"Cancer-Start"})>=0)&&(&Date_Cmp($Star_Sign_Dates{"Cancer-End"},$Date)>=0))
		{
			$Star_Sign="Cancer";
		}
		elsif((&Date_Cmp($Date,$Star_Sign_Dates{"Leo-Start"})>=0)&&(&Date_Cmp($Star_Sign_Dates{"Leo-End"},$Date)>=0))
		{
			$Star_Sign="Leo";
		}
		elsif((&Date_Cmp($Date,$Star_Sign_Dates{"Virgo-Start"})>=0)&&(&Date_Cmp($Star_Sign_Dates{"Virgo-End"},$Date)>=0))
		{
			$Star_Sign="Virgo";
		}
		elsif((&Date_Cmp($Date,$Star_Sign_Dates{"Libra-Start"})>=0)&&(&Date_Cmp($Star_Sign_Dates{"Libra-End"},$Date)>=0))
		{
			$Star_Sign="Libra";
		}
		elsif((&Date_Cmp($Date,$Star_Sign_Dates{"Scorpio-Start"})>=0)&&(&Date_Cmp($Star_Sign_Dates{"Scorpio-End"},$Date)>=0))
		{
			$Star_Sign="Scorpio";
		}
		elsif((&Date_Cmp($Date,$Star_Sign_Dates{"Sagittarius-Start"})>=0)&&(&Date_Cmp($Star_Sign_Dates{"Sagittarius-End"},$Date)>=0))
		{
			$Star_Sign="Sagittarius";
		}
		elsif(((&Date_Cmp($Date,$Star_Sign_Dates{"Capricorn-Start"})>=0)&&(&Date_Cmp($Date,$Star_Sign_Dates{"Year-End"})<=0))||((&Date_Cmp($Date,$Star_Sign_Dates{"Year-Start"})>=0)&&(&Date_Cmp($Date,$Star_Sign_Dates{"Capricorn-End"})<=0)))
		{
			$Star_Sign="Capricorn";
		}
		elsif((&Date_Cmp($Date,$Star_Sign_Dates{"Aquarius-Start"})>=0)&&(&Date_Cmp($Star_Sign_Dates{"Aquarius-End"},$Date)>=0))
		{
			$Star_Sign="Aquarius";
		}
		elsif((&Date_Cmp($Date,$Star_Sign_Dates{"Pisces-Start"})>=0)&&(&Date_Cmp($Star_Sign_Dates{"Pisces-End"},$Date)>=0))
		{
			$Star_Sign="Pisces";
		}
		else{}

		if($Star_Sign ne ""){return "Star Sign : $Star_Sign";}

		elsif($Star_Sign eq ""){return;}

};

1;

