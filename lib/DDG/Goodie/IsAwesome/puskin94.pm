package DDG::Goodie::IsAwesome::puskin94;
# ABSTRACT: puskin94's first Goodie


use DDG::Goodie;

zci answer_type => "is_awesome_puskin94";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome puskin94";
description "My first Goodie, it let's the world know that puskin94 is awesome";
primary_example_queries "duckduckhack puskin94";
category "special";
topics "special_interest", "geek";
secondary_example_queries "optional -- demonstrate any additional triggers";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/puskin94/puskin94.pm";
attribution github => ["https://github.com/puskin94", "puskin94"],
            twitter => "TwitterUserName";


triggers start => "duckduckhack puskin94";

handle remainder => sub {
	return if $_;
    return "puskin94 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;