package DDG::Goodie::IsAwesome::vedantham;

use DDG::Goodie;

zci answer_type => "is_awesome_vedantham";
zci is_cached   => 1;

name "IsAwesome vedantham";
description "My first Goodie, it let's the world know that vedantham is awesome";
primary_example_queries "duckduckhack vedantham";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/vedantham.pm";
attribution github => ["https://github.com/vedantham", "vedantham"];

triggers start => "duckduckhack vedantham";

handle remainder => sub {
    return if $_;
    return "vedantham is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
