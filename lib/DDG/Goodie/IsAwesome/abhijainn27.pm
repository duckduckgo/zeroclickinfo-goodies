package DDG::Goodie::IsAwesome::abhijainn27;
# ABSTRACT: abhijainn27 first Goodie Hack !!
# CATEGORY "DuckDuckHack Goodie";
# TOPICS "Web Development", "geek";
use DDG::Goodie;

zci answer_type => "is_awesome_abhijainn27";
zci is_cached   => 1;


name "IsAwesome abhijainn27";
description "My First Goodie Hack !! ";
primary_example_queries "duckduckhack abhijainn27";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/abhijainn27.pm";
attribution github => ["https://github.com/abhijainn27", "abhijainn27"],
            twitter => "abhijainn27";


triggers start => "duckduckhack abhijainn27";


handle remainder => sub {
    return if $_;
	return "abhijainn27 is a DDG user and has successfully completed the DuckDuckHack Goodie tutorial!";

};

1;
