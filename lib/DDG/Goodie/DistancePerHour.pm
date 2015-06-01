package DDG::Goodie::DistancePerHour;
with DDG::GoodieRole::NumberStyler;

use DDG::Goodie;

zci answer_type => "Conversion";
zci is_cached   => 1;

name "DistancePerHour";
description "Converts kph to mph and vise versa.";
primary_example_queries "5 mph to kph", "5 m/h to k/h";
category "calculations";
topics "math";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DistancePerHour.pm";
attribution github => ["BigxMac", "Jared Stefanowicz"];

triggers any => "mph", "mih" , "m/h" , "mi/h", "kph", "kih", "k/h", "km/h";

handle query => sub {
	
    # check structure with a regex 
    if ($_ =~ /^(\d+)\s?(.+)\s(?:to\s)?(.+)$/)
    {
        my $number = $1;
        my $word = $2; 
     
        if($word  =~ 'mph' || $word =~ 'mih' || $word =~ 'm\/h' || $word =~ 'mi\/h')
        {
            my $answer = $number * 0.621371192;
            return "$number mph converts to ".sprintf("%.3f kph", $answer);
        }
     
        elsif ($word  =~ 'kph' || $word =~ 'kmh' || $word =~ 'km\/h' || $word =~ 'k\/h')
        {
            my $answer = $number * 1.609344;
            return "$number kph converts to ".sprintf("%.3f mph", $answer);
        }
    }
};
1;
