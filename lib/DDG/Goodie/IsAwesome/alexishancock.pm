package DDG::Goodie::IsAwesome::alexishancock;
# ABSTRACT: alexishancock's first goodie

use DDG::Goodie;

zci answer_type => "is_awesome_alexishancock";
zci is_cached   => 1;

name "IsAwesome alexishancock";
description "My first Goodie, it let's the world know that GitHubUsername is awesome";
primary_example_queries "duckduckhack alexishancock";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/alexishancock.pm";
attribution github => ["https://github.com/alexishancock", "Alexis Hancock"],
            twitter => "nappy_techie";

triggers start => "duckduckhack alexishancock";

handle remainder => sub {
    return if $_;
    return "Alexis Hancock is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
