package DDG::Goodie::DistancePerHour;

use DDG::Goodie;

zci answer_type => "Conversion";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
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
handle remainder => sub {
	
    # check structure with a regex 
    if ($_ =~ /^(\d)*\s(.)./)
    {
    
     my $number = $1;
     my $unit = $2;
     
        if ($unit =~ 'mph' || $unit =~ 'mih' || $unit =~ 'm\/h' || $unit =~ 'mi\/h')
        {
            return $number * 0.621;
        }
        elsif ($unit =~ 'kph' || $unit =~ 'kmh' || $unit =~ 'km\/h' || $unit =~ 'k\/h')
        {
            return $number * 1.609;
        }
    
    }
    
};
1;
