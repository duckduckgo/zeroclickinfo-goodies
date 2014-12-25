package DDG::Goodie::IsAwesome::MaxPower9;
# ABSTRACT: MaxPower9's first Goodie


use DDG::Goodie;

zci answer_type => "is_awesome_max_power9";
zci is_cached   => 1;


name "IsAwesome MaxPower9";
description "My first Goodie, it let's the world know that MaxPower9 is awesome";
primary_example_queries "duckduckhack MaxPower9";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/MaxPower9.pm";
attribution github => ["https://github.com/MaxPower9", "MaxPower9"],
            twitter => "gtmurff";

triggers start => "duckduckhack maxpower9";

handle remainder => sub {

    return if $_;
    
    return "MaxPower9 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
