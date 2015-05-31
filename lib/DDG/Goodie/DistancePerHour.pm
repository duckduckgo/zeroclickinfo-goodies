package DDG::Goodie::DistancePerHour;
with DDG::GoodieRole::NumberStyler;

use DDG::Goodie;

zci answer_type => "Conversion";
zci is_cached   => 1;

name "DistancePerHour";
description "Converts kph to mph and vise versa.";
primary_example_queries "5 mph to kph", "5 m/h to k/h";
secondary_example_queries "optional -- demonstrate any additional triggers";
category "calculations";
topics "math";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DistancePerHour.pm";
attribution github => ["BigxMac", "Jared Stefanowicz"];

# Triggers
triggers any => "mph", "mih" , "m/h" , "mi/h", "kph", "kih", "k/h", "km/h";

# Handle statement
handle query => sub {
	
    # check structure with a regex 
    if ($_ =~ /(\d)(.)(.)/)
    {
        my $number = $1;
        print("$number");
     
        if($_  =~ 'mph' || $_ =~ 'mih' || $_ =~ 'm\/h' || $_ =~ 'mi\/h')
        {
            return $number * 0.621371192;
        }
     
        elsif ($_  =~ 'kph' || $_ =~ 'kmh' || $_ =~ 'km\/h' || $_ =~ 'k\/h')
        {
            return $number * 1.609344;
        }
    }
};
1;
