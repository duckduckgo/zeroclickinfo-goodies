package DDG::Goodie::IsAwesome::SueSmith;
# ABSTRACT: SueSmith's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_sue_smith";
zci is_cached   => 1;

name "IsAwesome SueSmith";
description "My first Goodie, it lets the world know that Sue Smith is awesome";
primary_example_queries "duckduckhack SueSmith";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/SueSmith.pm";
attribution github => ["https://github.com/SueSmith", "SueSmith"],
            twitter => "braindeadair";

triggers start => "duckduckhack suesmith";

handle remainder => sub {

    return if $_;
	return "SueSmith is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
