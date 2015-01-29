package DDG::Goodie::IsAwesome::justinvee;
# ABSTRACT: justinvee's first Goodie.

use DDG::Goodie;

zci answer_type => "is_awesome_justinvee";
zci is_cached   => 1;


name "IsAwesome justinvee";
description "My first Goodie, it let's the world know that justinvee is awesome";
primary_example_queries "duckduckhack justinvee";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/justinvee.pm";
attribution github => ["https://github.com/justinvee", "Justin V"],
            twitter => "justinvekinis";

triggers start => "duckduckhack justinvee";

handle remainder => sub {

	return if $_; # Guard against "no answer"

	return "justinvee is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
