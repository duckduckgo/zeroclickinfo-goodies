package DDG::Goodie::IsAwesome::jesuruban;
# ABSTRACT: Jesu Ruban's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_jesuruban";
zci is_cached   => 1;

name "IsAwesome jesuruban";
description "My first Goodie, it let's the world know that Jesu is awesome";
primary_example_queries "duckduckhack jesuruban";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/jesuruban.pm";
attribution github => ["https://github.com/jesuruban", "jesuruban"],        
            twitter => "jesuruban";

triggers start => "duckduckhack jesuruban";

handle remainder => sub {
    return if $_;
    return "Jesu Ruban is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
