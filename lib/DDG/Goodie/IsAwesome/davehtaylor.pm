package DDG::Goodie::IsAwesome::davehtaylor;
# ABSTRACT: davehtaylor's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_davehtaylor";
zci is_cached   => 1;

name "IsAwesome davehtaylor";
description "My first Goodie, it let's the world know that davehtaylor is awesome";
primary_example_queries "duckduckhack davehtaylor";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/davehtaylor.pm";
attribution github => ["https://github.com/davehtaylor", "davehtaylor"],
            twitter => "thedavehtaylor";

triggers start => "duckduckhack davehtaylor";

handle remainder => sub {
    return if $_;
	return "davehtaylor is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
