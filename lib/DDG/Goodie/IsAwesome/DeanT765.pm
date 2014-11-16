package DDG::Goodie::IsAwesome::DeanT765;
# ABSTRACT: DeanT765's first Goodie 

use DDG::Goodie;

zci answer_type => "is_awesome_dean_t765";
zci is_cached   => 1;

name "IsAwesome DeanT765";
description "My first Goodie, it let's the world know that DeanT765 is awesome";
primary_example_queries "duckduckhack DeanT765";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/DeanT765.pm";
attribution github => ["https://github.com/DeanT765", "DeanT765"],
            twitter => "deanthomasson";

triggers start => "duckduckhack deant765";

handle remainder => sub {
    return if $_;
    return "DeanT765 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
