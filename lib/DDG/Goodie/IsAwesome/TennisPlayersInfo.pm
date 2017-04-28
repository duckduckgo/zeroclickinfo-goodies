package DDG::Goodie::IsAwesome::TennisPlayersInfo;
# ABSTRACT: Tennis Player basic info e.g., birth date, year, birth place.

use DDG::Goodie;

zci answer_type => "is_awesome_tennis_players_info";
zci is_cached   => 1;


name "IsAwesome TennisPlayersInfo";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";

category "physical_properties";

topics "entertainment";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/TennisPlayersInfo.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";


triggers any => "roger federer","roger", "federer","novak","djokovic","novak djokovic";


handle sub {

     
     my $return = '';
     my $query = $_;
    
     
     if($query =~ /(roger|federer|roger federer)/gsi){
    
     $return = "Professional Tennis Player. Born: August 8, 1981 (age 33), Basel, Switzerland";
                
     }
     
     if($query =~ /(novak|djokovic|novak djokovic)/gsi){
          $return = "Professional Tennis Player. Born: May 22, 1987 (age 27), Belgrade, Serbia";
     }
     
    

    return "$return";
};

1;
