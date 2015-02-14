package DDG::Goodie::IsAwesome::ghoust_xxx;
# ABSTRACT: ghoust_xxx first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_ghoust_xxx";
zci is_cached   => 1;

name "IsAwesome ghoust_xxx";
description "My first Goodie, it let's the world know that ghoust_xxx is awesome";
primary_example_queries "duckduckhack ghoust_xxx";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/ghoust_xxx.pm";
attribution github => ["https://github.com/ghoust-xxx", "ghoust_xxx"];

triggers start => "duckduckhack ghoust_xxx";

handle remainder => sub {
    return if $_;
    return "ghoust_xxx is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
