package DDG::Goodie::IsAwesome::ashleyglidden;
# ABSTRACT: ashleyglidden's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_ashleyglidden";
zci is_cached   => 1;

name "IsAwesome ashleyglidden";
description "My first Goodie, it let's the world know that ashleyglidden is awesome";
primary_example_queries "duckduckhack ashleyglidden";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/ashleyglidden.pm";
attribution github => ["https://github.com/ashleyglidden", "ashleyglidden"],
            web     => ['http://ashleyglidden.com', 'Ashley Glidden'],
            twitter => "aishleyng";

triggers start => "duckduckhack ashleyglidden";

handle remainder => sub {
    return if $_;
    return "ashleyglidden is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
