package DDG::Goodie::IsAwesome::Marneus68;
# ABSTRACT: Marneus68's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_marneus68";
zci is_cached   => 1;

name "IsAwesome Marneus68";
description "My first Goodie, it let's the world know that GitHubUsername is awesome";
primary_example_queries "duckduckhack Marneus68";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/Marneus68.pm";
attribution github => ["Marneus68", "Duane Bekaert"];

triggers start => "duckduckhack marneus68";

handle remainder => sub {
    return if $_;
    return "Marneus68 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
