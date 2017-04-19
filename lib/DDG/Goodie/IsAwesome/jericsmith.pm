package DDG::Goodie::IsAwesome::jericsmith;
# ABSTRACT: jericsmith's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_jericsmith";
zci is_cached   => 1;

name "IsAwesome jericsmith";
description "My first Goodie, it let's the world know that jericsmith is awesome.";
primary_example_queries "duckduckhack jericsmith";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/jericsmith.pm";
attribution github => ["https://github.com/jericsmith", "jericsmith"]
            twitter => "i_am_jericsmith";

triggers start => "duckduckhack jericsmith";

handle remainder => sub {
    return if $_;
	return "jericsmith is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
