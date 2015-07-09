package DDG::Goodie::IsAwesome::rafacas;
# ABSTRACT: rafacas' first Goodie 

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_rafacas";
zci is_cached   => 1;

name "IsAwesome rafacas";
description "My first Goodie, it lets the world know that rafacas is awesome";
primary_example_queries "duckduckhack rafacas";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/rafacas.pm";
attribution github => ["https://github.com/rafacas", "rafacas"],
            twitter => "rafacas";

triggers start => "duckduckhack rafacas";

handle remainder => sub {
        return if $_;
	return "rafacas is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
