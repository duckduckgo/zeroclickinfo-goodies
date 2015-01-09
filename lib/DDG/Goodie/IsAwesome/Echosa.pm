package DDG::Goodie::IsAwesome::Echosa;

use DDG::Goodie;

zci answer_type => "is_awesome_echosa";
zci is_cached   => 1;

name "IsAwesome Echosa";
description "My first Goodie. It lets the world know that Echosa is awesome.";
primary_example_queries "duckduckhack echosa";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/Echosa.pm";
attribution github => ["https://github.com/echosa", "Echosa"],
            twitter => "echosa";

triggers start => "duckduckhack echosa";

handle remainder => sub {
    return if $_;
    return "Echosa is awesome and has successfully completed the DuckDuckHack Goodie tutorial!"
};

1;
